export default {
  // System level
  log: {
    level: process.env.LOG_LEVEL || 'error',
    enabled: Boolean(process.env.LOG_ENABLED) || false,
    redact: process.env.LOG_REDACT?.split(',') ?? [],
  },

  // Application level
  queue: {
    sqs: {
      url: process?.env?.QueueUrl ?? '',
      defaultRegion: process.env.DefaultRegion ?? 'us-east-1',
    }
  },
  webhook: {
    signature: {
      secret: process.env.WEBHOOK_SIGNATURE_SECRET ?? '',
      algo: process.env.WEBHOOK_SIGNATURE_ALGO ?? 'sha256',
      header: process.env.WEBHOOK_SIGNATURE_HEADER ?? 'x-hub-signature-256',
    }
  }
};
