export default {
  // System level
  log: {
    level: process.env.LOG_LEVEL || 'error',
    enabled: Boolean(process.env.LOG_ENABLED) || false,
    redact: process.env.LOG_REDACT?.split(',') ?? [],
  },
};
