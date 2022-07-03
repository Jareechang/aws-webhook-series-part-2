const { exec } = require('child_process');
const fs = require('fs');

/*
 *
 * Cleans the dist folder
 *
 * **/
async function runClean() {
  return new Promise((resolve, reject) => {
    exec('pnpm clean', (err, stdout, stderr) => {
      if (err) return reject(stderr);
      return resolve(stdout);
    });
  });
}

/*
 *
 * Cleans the dist folder
 *
 * **/
async function runInstall(env) {
  console.log('runProdInstall: starting production installation');
  return new Promise((resolve, reject) => {
    if (env === 'prod') {
      exec('pnpm install --prod --ignore-scripts --prefer-offline', (err, stdout, stderr) => {
        if (err) return reject(stderr);
        return resolve(stdout);
      });
    }
    exec('pnpm install', (err, stdout, stderr) => {
      if (err) return reject(stderr);
      return resolve(stdout);
    });
  });
}

/*
 *
 * Append lambda code to existing zip file with dependencies
 *
 * **/
async function generateLambdaZipFile() {
  const filename = process.env.LAMBDA_ZIP_FILENAME || 'main.zip';
  console.log('Creating new zip file... ', filename);
  return new Promise((resolve, reject) => {
    exec(`zip -ur ${filename} dist`, (err, stdout, stderr) => {
      if (err) {
        console.log(err, stderr);
        return reject(stderr)
      };
      if (stdout) {
        console.log(`File created. name: ${filename}`);
        return resolve(filename);
      }
    });
  });
}

/*
 *
 * Generate a  zip file of the node_module deps
 *
 * **/
async function generateDependencyZipFile() {
  const filename = process.env.LAMBDA_ZIP_FILENAME || 'main.zip';
  const hasNodeModules = fs.existsSync('node_modules');
  if (!hasNodeModules) return;
  console.log('Creating new zip file... ', filename);
  return new Promise((resolve, reject) => {
    exec(`zip -r ${filename} node_modules`, (err, stdout, stderr) => {
      if (err) return reject(stderr);
      if (stdout) {
        console.log(`File created. name: ${filename}`);
        return resolve(filename);
      }
    });
  });
}

module.exports = {
  runClean,
  runInstall,
  generateLambdaZipFile,
  generateDependencyZipFile
};
