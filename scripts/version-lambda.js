const packageJson = require('../package.json');
const {exec} = require('child_process');
const fs = require('fs').promises;
const common = require('./common');
const S3 = require('aws-sdk/clients/s3');
const Lambda = require('aws-sdk/clients/lambda');
const { v4: uuid } = require('uuid');

const s3 = new S3({
  region: process.env.AWS_DEFAULT_REGION || 'us-east-1',
  apiVersion: '2006-03-01'
});
const lambda = new Lambda({
  region: process.env.AWS_DEFAULT_REGION || 'us-east-1'
});

async function uploadToS3() {
  const filename = process.env.LAMBDA_ZIP_FILENAME || 'main';
  const file = await fs.readFile(`${filename}.zip`);
  const Bucket = process.env.AWS_S3_BUCKET;
  const Key = `${filename.replace('/', '-')}-${uuid()}.zip`;
  await s3.putObject({
    Bucket,
    Key,
    Body: file
  }).promise();
  return {
    filename,
    Bucket,
    Key,
  };
}

async function publishLambdaVersion({ Bucket, Key }) {
  const params = {
    FunctionName: process.env.AWS_LAMBDA_FUNCTION_NAME,
    Publish: true,
    S3Bucket: Bucket,
    S3Key: Key,
  };
  return lambda.updateFunctionCode(params).promise();
}

async function updateLambdaAlias(version) {
  const params = {
    FunctionName: process.env.AWS_LAMBDA_FUNCTION_NAME,
    FunctionVersion: version,
    Name: process.env.AWS_LAMBDA_ALIAS_NAME,
  };
  return lambda.updateAlias(params).promise();
}

async function main() {
  try {
    // Update to S3
    const { filename, Bucket, Key } = await uploadToS3();
    console.log('Function asset Uploaded to', {
      filename,
      Bucket,
      Key
    });
    // Publish Lambda version
    const { Version } = await publishLambdaVersion({ Bucket, Key });
    console.log('Published Lambda', {
      FunctionName: process.env.AWS_LAMBDA_FUNCTION_NAME,
      Version,
    });
    // Update Lambda Alias
    await updateLambdaAlias(Version);
  } catch (error) {
    console.error('failed to version lambda', {
      file: 'scripts/version-lambda.js',
      error,
    });
  }
}

main();
