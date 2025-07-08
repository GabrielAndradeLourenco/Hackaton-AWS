import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBClient, QueryCommand } from '@aws-sdk/client-dynamodb';

const dynamoClient = new DynamoDBClient({});

export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const campaign = event.pathParameters?.campaign;

    if (!campaign) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'campaign is required' })
      };
    }

    const response = await dynamoClient.send(new QueryCommand({
      TableName: process.env.CONTENT_TABLE_NAME,
      IndexName: 'CampaignStatusIndex',
      KeyConditionExpression: 'category = :campaign AND #status = :status',
      ExpressionAttributeNames: {
        '#status': 'status'
      },
      ExpressionAttributeValues: {
        ':campaign': { S: campaign },
        ':status': { S: 'approved' }
      }
    }));

    const items = response.Items?.map(item => ({
      contentId: item.contentId.S,
      productId: item.productId.S,
      category: item.category.S,
      imageUrl: item.imageUrl?.S,
      createdAt: item.createdAt.S
    })) || [];

    return {
      statusCode: 200,
      body: JSON.stringify(items)
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal server error' })
    };
  }
};