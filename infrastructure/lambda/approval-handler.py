import json
import boto3
import uuid
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
sns = boto3.client('sns')

CONTENTS_TABLE = os.environ['CONTENTS_TABLE']
APPROVALS_TABLE = os.environ['APPROVALS_TABLE']
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

def handler(event, context):
    try:
        content_id = event['pathParameters']['id']
        body = json.loads(event['body'])
        action = body.get('action', 'approve')  # approve or reject
        comment = body.get('comment', '')
        
        # Get content
        contents_table = dynamodb.Table(CONTENTS_TABLE)
        content = contents_table.get_item(Key={'content_id': content_id})
        
        if 'Item' not in content:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Content not found'})
            }
        
        # Update content status
        new_status = 'approved' if action == 'approve' else 'rejected'
        contents_table.update_item(
            Key={'content_id': content_id},
            UpdateExpression='SET #status = :status, updated_at = :updated_at',
            ExpressionAttributeNames={'#status': 'status'},
            ExpressionAttributeValues={
                ':status': new_status,
                ':updated_at': datetime.utcnow().isoformat()
            }
        )
        
        # Create approval record
        approval_id = str(uuid.uuid4())
        approvals_table = dynamodb.Table(APPROVALS_TABLE)
        
        approvals_table.put_item(
            Item={
                'approval_id': approval_id,
                'content_id': content_id,
                'status': new_status,
                'comment': comment,
                'created_at': datetime.utcnow().isoformat()
            }
        )
        
        # Send notification
        message = f"Content {content_id} has been {new_status}"
        if comment:
            message += f" with comment: {comment}"
            
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=message,
            Subject=f"Content {action.title()}"
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'approval_id': approval_id,
                'content_id': content_id,
                'status': new_status,
                'message': f'Content {new_status} successfully'
            })
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }