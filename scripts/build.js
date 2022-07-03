const { generateLambdaZipFile } = require('./common');
const esbuild = require('esbuild');

/*
 *
 * Run the build process
 *
 * **/
async function runBuild() {
  return new Promise((resolve, reject) => {
    esbuild.build({
      entryPoints: ['src/index.ts'],
      outfile: 'dist/index.js',
      format: 'cjs',
      platform: 'node',
      target: 'es2015',
      bundle: true,
    })
    .then(resolve)
    .catch(reject)
  });
}

async function main() {
  try {
    await runBuild();
    await generateLambdaZipFile();
  } catch (error) {
    console.error('build error: ', {
      file: 'scripts/build.js',
      error,
    })
  }
}

main();
