import {
  APIGatewayProxyEvent,
  APIGatewayProxyResult
} from 'aws-lambda';

// Default starter
export const handler = async(
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log('Event : ', JSON.stringify({
    messages: 'Changed from deployment webhook part 2',
    event,
  }, null, 4));
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: 'success',
    }),
  }
}
