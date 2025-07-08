import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBClient, GetItemCommand } from '@aws-sdk/client-dynamodb';

const dynamoClient = new DynamoDBClient({});

export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const contentId = event.pathParameters?.contentId;

    if (!contentId) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'contentId is required' })
      };
    }

    const response = await dynamoClient.send(new GetItemCommand({
      TableName: process.env.CONTENT_TABLE_NAME,
      Key: { contentId: { S: contentId } }
    }));

    if (!response.Item) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: 'Content not found' })
      };
    }

    const item = {
      contentId: response.Item.contentId.S,
      productId: response.Item.productId.S,
      category: response.Item.category.S,
      status: response.Item.status.S,
      createdAt: response.Item.createdAt.S,
      ...(response.Item.imageUrl && { imageUrl: response.Item.imageUrl.S }),
      ...(response.Item.errorMessage && { errorMessage: response.Item.errorMessage.S })
    };

    return {
      statusCode: 200,
      body: JSON.stringify(item)
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal server error' })
    };
  }
};