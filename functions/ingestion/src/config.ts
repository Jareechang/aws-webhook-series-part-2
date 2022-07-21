export default {
  // System level
  log: {
    level: process.env.LOG_LEVEL || 'error',
    enabled: Boolean(process.env.LOG_ENABLED) || false,
    redact: process.env.LOG_REDACT?.split(',') ?? [],
  },
  // Application level

  // configuration for AWS SQS
  queue: {
    sqs: {
      url: process?.env?.QueueUrl ?? '',
      defaultRegion: process.env.DefaultRegion ?? 'us-east-1',
    }
  },

  // configuration for the custom webhook
  webhook: {
    signature: {
      secret: process.env.WebhookSignatureSecret ?? '',
      algo: process.env.WebhookSignatureAlgo ?? 'sha256',
      header: process.env.WebhookSignatureHeader ?? 'x-hub-signature-256',
    }
  }
};
