import json
import boto3
import uuid
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')
bedrock = boto3.client('bedrock-runtime')

PRODUCTS_TABLE = os.environ['PRODUCTS_TABLE']
CONTENTS_TABLE = os.environ['CONTENTS_TABLE']
S3_BUCKET = os.environ['S3_BUCKET']

def handler(event, context):
    try:
        body = json.loads(event['body'])
        product_id = body['product_id']
        content_type = body.get('type', 'banner')  # banner or social_post
        
        # Get product info
        products_table = dynamodb.Table(PRODUCTS_TABLE)
        product = products_table.get_item(Key={'product_id': product_id})
        
        if 'Item' not in product:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Product not found'})
            }
        
        product_data = product['Item']
        
        # Generate content with Bedrock
        prompt = f"""
        Crie um {content_type} para o produto:
        Nome: {product_data['name']}
        Categoria: {product_data['category']}
        Descrição: {product_data.get('description', '')}
        
        O conteúdo deve ser atrativo e focado no público brasileiro.
        """
        
        # Call Bedrock (Claude)
        response = bedrock.invoke_model(
            modelId='anthropic.claude-3-haiku-20240307-v1:0',
            body=json.dumps({
                'anthropic_version': 'bedrock-2023-05-31',
                'max_tokens': 1000,
                'messages': [{'role': 'user', 'content': prompt}]
            })
        )
        
        result = json.loads(response['body'].read())
        generated_text = result['content'][0]['text']
        
        # Save content to DynamoDB
        content_id = str(uuid.uuid4())
        contents_table = dynamodb.Table(CONTENTS_TABLE)
        
        contents_table.put_item(
            Item={
                'content_id': content_id,
                'product_id': product_id,
                'type': content_type,
                'text': generated_text,
                'status': 'pending',
                'created_at': datetime.utcnow().isoformat()
            }
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'content_id': content_id,
                'text': generated_text,
                'status': 'pending'
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }