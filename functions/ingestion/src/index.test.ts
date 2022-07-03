import { handler } from './index';

describe('lambda.handler', () => {
  it('should return with 200 with the default message', async() => {
    const event = { body: JSON.stringify(null) };
    // @ts-ignore
    await expect(handler(event))
      .resolves
      .toEqual({
        statusCode: 200,
        body: expect.stringMatching(
          'default message from ingestion'
        )
      });
  });
});
