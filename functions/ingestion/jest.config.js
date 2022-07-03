const commonJestConfig = require('../../jest-common.config');

commonJestConfig.moduleNameMapper = {
  "@app/(.*)": "<rootDir>/src/$1"
};

module.exports = commonJestConfig;
