import { DynamoDBClient, GetItemCommand, UpdateItemCommand, QueryCommand } from '@aws-sdk/client-dynamodb';
import { BedrockRuntimeClient, InvokeModelCommand } from '@aws-sdk/client-bedrock-runtime';
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';

const dynamoClient = new DynamoDBClient({});
const bedrockClient = new BedrockRuntimeClient({});
const s3Client = new S3Client({});

export const handler = async (event: { contentId: string }) => {
  const { contentId } = event;

  try {
    // Fetch job details from DynamoDB
    const jobResponse = await dynamoClient.send(new GetItemCommand({
      TableName: process.env.CONTENT_TABLE_NAME,
      Key: { contentId: { S: contentId } }
    }));

    if (!jobResponse.Item) {
      throw new Error('Job not found');
    }

    const category = jobResponse.Item.category.S!;
    const productId = jobResponse.Item.productId.S!;

    // Query trends based on category
    const trendsResponse = await dynamoClient.send(new QueryCommand({
      TableName: process.env.TRENDS_TABLE_NAME,
      IndexName: 'CategoryIndex',
      KeyConditionExpression: 'category = :category',
      ExpressionAttributeValues: {
        ':category': { S: category }
      }
    }));

    const trends = trendsResponse.Items?.map(item => item.name.S).join(', ') || '';

    // Construct prompt for Bedrock
    const prompt = `Create a marketing image for product ${productId} incorporating these trends: ${trends}. Make it visually appealing and commercial.`;

    // Invoke Bedrock
    const bedrockResponse = await bedrockClient.send(new InvokeModelCommand({
      modelId: 'amazon.titan-image-generator-v1',
      body: JSON.stringify({
        taskType: 'TEXT_IMAGE',
        textToImageParams: {
          text: prompt
        },
        imageGenerationConfig: {
          numberOfImages: 1,
          quality: 'standard',
          cfgScale: 8.0,
          height: 1024,
          width: 1024
        }
      })
    }));

    const responseBody = JSON.parse(new TextDecoder().decode(bedrockResponse.body));
    const base64Image = responseBody.images[0];

    // Upload to S3
    const imageBuffer = Buffer.from(base64Image, 'base64');
    const s3Key = `generated-images/${contentId}.png`;

    await s3Client.send(new PutObjectCommand({
      Bucket: process.env.S3_BUCKET_NAME,
      Key: s3Key,
      Body: imageBuffer,
      ContentType: 'image/png'
    }));

    const imageUrl = `https://${process.env.S3_BUCKET_NAME}.s3.amazonaws.com/${s3Key}`;

    // Update DynamoDB with success
    await dynamoClient.send(new UpdateItemCommand({
      TableName: process.env.CONTENT_TABLE_NAME,
      Key: { contentId: { S: contentId } },
      UpdateExpression: 'SET #status = :status, imageUrl = :imageUrl',
      ExpressionAttributeNames: { '#status': 'status' },
      ExpressionAttributeValues: {
        ':status': { S: 'awaiting_approval' },
        ':imageUrl': { S: imageUrl }
      }
    }));

  } catch (error) {
    // Update DynamoDB with failure
    await dynamoClient.send(new UpdateItemCommand({
      TableName: process.env.CONTENT_TABLE_NAME,
      Key: { contentId: { S: contentId } },
      UpdateExpression: 'SET #status = :status, errorMessage = :error',
      ExpressionAttributeNames: { '#status': 'status' },
      ExpressionAttributeValues: {
        ':status': { S: 'failed' },
        ':error': { S: error instanceof Error ? error.message : 'Unknown error' }
      }
    }));
  }
};