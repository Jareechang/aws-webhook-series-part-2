import { handler } from './index';
import { mockEvent } from '@app/__mocks__';

jest.mock('@app/config', () => ({
  __esModule: true,
  default: {
    webhook: {
      signature: {
        secret: 'test123',
        algo: 'sha256',
        header: 'x-hub-signature-256'
      }
    }
  }
}))

describe('lambda.handler', () => {
  afterEach(() => {
    jest.resetAllMocks();
    jest.clearAllMocks();
  });

  it('should return with 200 with the default message', async() => {
    // @ts-ignore
    await expect(handler(mockEvent))
      .resolves
      .toEqual({
        statusCode: 200,
        body: expect.stringMatching(
          'success'
        )
      });
  });
});
