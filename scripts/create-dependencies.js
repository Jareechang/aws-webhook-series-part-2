const { generateDependencyZipFile } = require('./common');

async function main() {
  try {
    await generateDependencyZipFile();
  } catch (error) {
    console.error('create dependencies failed : ', {
      file: 'scripts/create-dependencies.js',
      error,
    });
  }
}

main();
