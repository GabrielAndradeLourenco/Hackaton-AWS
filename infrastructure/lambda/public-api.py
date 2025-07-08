import json
import boto3
import os
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')

PRODUCTS_TABLE = os.environ['PRODUCTS_TABLE']
CONTENTS_TABLE = os.environ['CONTENTS_TABLE']
APPROVALS_TABLE = os.environ['APPROVALS_TABLE']
CDN_DOMAIN = os.environ['CDN_DOMAIN']

def handler(event, context):
    try:
        # Get query parameters
        query_params = event.get('queryStringParameters') or {}
        category = query_params.get('category')
        content_type = query_params.get('type', 'banner')
        
        # Get approved contents
        contents_table = dynamodb.Table(CONTENTS_TABLE)
        
        if category:
            # First get products by category
            products_table = dynamodb.Table(PRODUCTS_TABLE)
            products_response = products_table.query(
                IndexName='category-index',
                KeyConditionExpression=Key('category').eq(category)
            )
            
            product_ids = [item['product_id'] for item in products_response['Items']]
            
            # Get contents for these products
            approved_contents = []
            for product_id in product_ids:
                content_response = contents_table.query(
                    IndexName='product-index',
                    KeyConditionExpression=Key('product_id').eq(product_id),
                    FilterExpression='#status = :status AND #type = :type',
                    ExpressionAttributeNames={
                        '#status': 'status',
                        '#type': 'type'
                    },
                    ExpressionAttributeValues={
                        ':status': 'approved',
                        ':type': content_type
                    }
                )
                approved_contents.extend(content_response['Items'])
        else:
            # Get all approved contents of specified type
            response = contents_table.scan(
                FilterExpression='#status = :status AND #type = :type',
                ExpressionAttributeNames={
                    '#status': 'status',
                    '#type': 'type'
                },
                ExpressionAttributeValues={
                    ':status': 'approved',
                    ':type': content_type
                }
            )
            approved_contents = response['Items']
        
        # Enrich with product data and CDN URLs
        products_table = dynamodb.Table(PRODUCTS_TABLE)
        enriched_contents = []
        
        for content in approved_contents:
            # Get product data
            product = products_table.get_item(
                Key={'product_id': content['product_id']}
            )
            
            if 'Item' in product:
                enriched_content = {
                    'content_id': content['content_id'],
                    'product': product['Item'],
                    'text': content['text'],
                    'type': content['type'],
                    'image_url': f"https://{CDN_DOMAIN}/{content['content_id']}.jpg" if content.get('image_key') else None,
                    'created_at': content['created_at']
                }
                enriched_contents.append(enriched_content)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'contents': enriched_contents,
                'count': len(enriched_contents)
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }