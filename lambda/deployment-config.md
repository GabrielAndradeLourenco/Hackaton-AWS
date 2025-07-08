# Lambda Deployment Configuration

## Environment Variables Required

### Generator Lambda
- `CONTENT_TABLE_NAME`: DynamoDB table name for content records
- `WORKER_LAMBDA_NAME`: Name/ARN of the worker Lambda function

### Worker Lambda
- `CONTENT_TABLE_NAME`: DynamoDB table name for content records
- `TRENDS_TABLE_NAME`: DynamoDB table name for trends data
- `S3_BUCKET_NAME`: S3 bucket name for storing generated images

### Status Lambda
- `CONTENT_TABLE_NAME`: DynamoDB table name for content records

### Approval Lambda
- `CONTENT_TABLE_NAME`: DynamoDB table name for content records
- `SNS_APPROVAL_TOPIC_ARN`: SNS topic ARN for approval notifications

### Public Lambda
- `CONTENT_TABLE_NAME`: DynamoDB table name for content records

## API Gateway Routes
- `POST /api/v1/content/generate` → Generator Lambda
- `GET /api/v1/content/status/{contentId}` → Status Lambda
- `PUT /api/v1/content/{contentId}/approve` → Approval Lambda
- `GET /api/v1/public/content/{campaign}` → Public Lambda

## DynamoDB Tables Structure

### Content Table
- Primary Key: `contentId` (String)
- Attributes: `productId`, `category`, `status`, `createdAt`, `imageUrl`, `errorMessage`

### Trends Table
- Primary Key: `trendId` (String)
- GSI: `CategoryIndex` with partition key `category`
- Attributes: `name`, `category`

## IAM Permissions Required

### Generator Lambda
- DynamoDB: PutItem on Content table
- Lambda: InvokeFunction on Worker Lambda

### Worker Lambda
- DynamoDB: GetItem, UpdateItem on Content table
- DynamoDB: Query on Trends table
- Bedrock: InvokeModel
- S3: PutObject

### Status Lambda
- DynamoDB: GetItem on Content table

### Approval Lambda
- DynamoDB: GetItem, UpdateItem on Content table
- SNS: Publish to approval topic

### Public Lambda
- DynamoDB: Query on Content table (CampaignStatusIndex GSI)