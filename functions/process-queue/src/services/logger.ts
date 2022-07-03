import pino from 'pino';

import config from '@app/config';

const logger = pino({
  enabled: config.log.enabled,
  level: config.log.level,
  redact: ['key', 'password', 'secret'].concat(config.log.redact ?? []),
});

export default logger;
