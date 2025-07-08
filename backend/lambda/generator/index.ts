import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBClient, PutItemCommand } from '@aws-sdk/client-dynamodb';
import { LambdaClient, InvokeCommand } from '@aws-sdk/client-lambda';
import { randomUUID } from 'crypto';

const dynamoClient = new DynamoDBClient({});
const lambdaClient = new LambdaClient({});

export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const body = JSON.parse(event.body || '{}');
    const { productId, category } = body;

    if (!productId || !category) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'productId and category are required' })
      };
    }

    const contentId = randomUUID();

    // Save initial record to DynamoDB
    await dynamoClient.send(new PutItemCommand({
      TableName: process.env.CONTENT_TABLE_NAME,
      Item: {
        contentId: { S: contentId },
        productId: { S: productId },
        category: { S: category },
        status: { S: 'processing' },
        createdAt: { S: new Date().toISOString() }
      }
    }));

    // Invoke worker Lambda asynchronously
    await lambdaClient.send(new InvokeCommand({
      FunctionName: process.env.WORKER_LAMBDA_NAME,
      InvocationType: 'Event',
      Payload: JSON.stringify({ contentId })
    }));

    return {
      statusCode: 202,
      body: JSON.stringify({ contentId })
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal server error' })
    };
  }
};