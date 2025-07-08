import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { DynamoDBClient, GetItemCommand, UpdateItemCommand } from '@aws-sdk/client-dynamodb';
import { SNSClient, PublishCommand } from '@aws-sdk/client-sns';

const dynamoClient = new DynamoDBClient({});
const snsClient = new SNSClient({});

export const handler = async (event: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    const contentId = event.pathParameters?.contentId;

    if (!contentId) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'contentId is required' })
      };
    }

    // Get current item to retrieve imageUrl
    const getResponse = await dynamoClient.send(new GetItemCommand({
      TableName: process.env.CONTENT_TABLE_NAME,
      Key: { contentId: { S: contentId } }
    }));

    if (!getResponse.Item || getResponse.Item.status.S !== 'awaiting_approval') {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: 'Content not found or not awaiting approval' })
      };
    }

    const imageUrl = getResponse.Item.imageUrl?.S;

    // Update status to approved
    await dynamoClient.send(new UpdateItemCommand({
      TableName: process.env.CONTENT_TABLE_NAME,
      Key: { contentId: { S: contentId } },
      UpdateExpression: 'SET #status = :status',
      ExpressionAttributeNames: { '#status': 'status' },
      ExpressionAttributeValues: {
        ':status': { S: 'approved' }
      }
    }));

    // Publish to SNS
    await snsClient.send(new PublishCommand({
      TopicArn: process.env.SNS_APPROVAL_TOPIC_ARN,
      Message: JSON.stringify({
        contentId,
        imageUrl
      })
    }));

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Content approved successfully' })
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Internal server error' })
    };
  }
};