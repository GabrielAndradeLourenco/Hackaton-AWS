import json
import boto3
from datetime import datetime
import uuid
from decimal import Decimal

class ReviewAPI:
    def __init__(self):
        self.dynamodb = boto3.resource('dynamodb')
        self.bedrock = boto3.client('bedrock-runtime')
        self.reviews_table = self.dynamodb.Table('retail-hackaton-reviews')
        self.products_table = self.dynamodb.Table('retail-hackaton-products')
        self.insights_table = self.dynamodb.Table('retail-hackaton-insights')
    
    def create_review(self, event):
        """POST /reviews - Create review (Store)"""
        try:
            body = json.loads(event.get('body', '{}'))
            
            # Validation
            required_fields = ['user_name', 'score', 'description', 'product_id']
            for field in required_fields:
                if field not in body:
                    return self._error_response(400, f'{field} is required')
            
            if not (1 <= body['score'] <= 5):
                return self._error_response(400, 'Score must be between 1 and 5')
            
            # Create review
            review_id = str(uuid.uuid4())
            
            self.reviews_table.put_item(
                Item={
                    'review_id': review_id,
                    'product_id': body['product_id'],
                    'user_name': body['user_name'],
                    'score': body['score'],
                    'description': body['description'],
                    'created_at': datetime.now().isoformat()
                }
            )
            
            return self._success_response({
                'review_id': review_id,
                'message': 'Review created successfully'
            })
            
        except Exception as e:
            return self._error_response(500, f'Internal error: {str(e)}')
    
    def list_reviews_admin(self, event):
        """GET /admin/reviews - List reviews with deep analysis (Admin)"""
        try:
            # Query parameters
            params = event.get('queryStringParameters') or {}
            product_id = params.get('product_id')
            
            if product_id:
                # Reviews for specific product
                reviews = self._get_product_reviews(product_id)
                analysis = self._generate_deep_analysis(reviews, product_id)
            else:
                # All recent reviews
                reviews = self._get_recent_reviews()
                analysis = self._generate_global_analysis(reviews)
            
            return self._success_response({
                'reviews': reviews,
                'analysis': analysis,
                'total': len(reviews)
            })
            
        except Exception as e:
            return self._error_response(500, f'Internal error: {str(e)}')
    
    def list_reviews_store(self, event):
        """GET /store/reviews - List reviews simplified (Store)"""
        try:
            params = event.get('queryStringParameters') or {}
            product_id = params.get('product_id')
            
            if not product_id:
                return self._error_response(400, 'product_id is required')
            
            reviews = self._get_product_reviews(product_id)
            summary = self._generate_simple_summary(reviews)
            
            # Format for store display
            formatted_reviews = []
            for review in reviews:
                formatted_reviews.append({
                    'user_name': review.get('user_name', 'Anonymous'),
                    'score': review['score'],
                    'description': review['description'],
                    'created_at': review['created_at'][:10]  # Date only
                })
            
            return self._success_response({
                'reviews': formatted_reviews,
                'summary': summary
            })
            
        except Exception as e:
            return self._error_response(500, f'Internal error: {str(e)}')
    
    def list_products(self, event):
        """GET /products - List all products"""
        try:
            # Get query parameters
            params = event.get('queryStringParameters') or {}
            category = params.get('category')
            
            if category:
                # Filter by category
                response = self.products_table.query(
                    IndexName='category-index',
                    KeyConditionExpression='category = :cat',
                    ExpressionAttributeValues={':cat': category}
                )
            else:
                # Get all products
                response = self.products_table.scan()
            
            products = response['Items']
            
            # Format response
            formatted_products = []
            for product in products:
                formatted_products.append({
                    'id': product['product_id'],
                    'name': product['name'],
                    'description': product['description'],
                    'category': {
                        'name': product['category'],
                    },
                    'inStock': True,
                    'slug': product['product_id'],
                    'price': float(product.get('price', 0))
                })
            
            return self._success_response({
                'products': formatted_products,
                'total': len(formatted_products)
            })
            
        except Exception as e:
            return self._error_response(500, f'Internal error: {str(e)}')
    
    def _get_product_reviews(self, product_id):
        """Busca reviews de um produto"""
        response = self.reviews_table.query(
            IndexName='product-index',
            KeyConditionExpression='product_id = :pid',
            ExpressionAttributeValues={':pid': product_id}
        )
        return response['Items']
    
    def _get_recent_reviews(self, limit=50):
        """Busca reviews recentes"""
        response = self.reviews_table.scan(Limit=limit)
        return response['Items']
    
    def _generate_deep_analysis(self, reviews, product_id):
        """Análise profunda para admin"""
        if not reviews:
            return {'message': 'Nenhum review encontrado'}
        
        # Buscar produto
        product = self._get_product_data(product_id)
        
        # Prepare context
        reviews_text = "\n".join([
            f"User: {r.get('user_name', 'Anonymous')} | Score: {r['score']}/5 | {r['description']}"
            for r in reviews
        ])
        
        prompt = f"""
        Analyze reviews for product "{product.get('name', 'Product')}" and generate DETAILED analysis:

        REVIEWS:
        {reviews_text}

        Return JSON with:
        {{
            "average_score": number,
            "score_distribution": {{"1": count, "2": count, ...}},
            "critical_issues": ["issue1", "issue2"],
            "manufacturing_issues": ["defect1", "defect2"],
            "delivery_issues": ["delay", "packaging"],
            "service_issues": ["slow response", "no answer"],
            "positive_points": ["quality", "speed"],
            "overall_sentiment": "positive/neutral/negative",
            "urgency": "high/medium/low",
            "priority_recommendations": ["action1", "action2", "action3"],
            "sales_impact": "high/medium/low",
            "trend": "improving/stable/declining"
        }}
        """
        
        return self._call_bedrock(prompt)
    
    def _generate_simple_summary(self, reviews):
        """Simplified analysis for store"""
        if not reviews:
            return {'average_score': 0, 'total_reviews': 0}
        
        total_score = sum(r['score'] for r in reviews)
        average_score = round(total_score / len(reviews), 1)
        
        # Count by stars
        distribution = {str(i): 0 for i in range(1, 6)}
        for review in reviews:
            distribution[str(review['score'])] += 1
        
        # Quick AI analysis
        recent_reviews = reviews[-10:]  # Last 10
        reviews_text = "\n".join([f"Score: {r['score']} - {r['description']}" for r in recent_reviews])
        
        prompt = f"""
        Briefly summarize these reviews:
        {reviews_text}
        
        Return JSON:
        {{
            "general_summary": "short text about the product",
            "main_compliments": ["compliment1", "compliment2"],
            "main_criticisms": ["criticism1", "criticism2"]
        }}
        """
        
        ai_summary = self._call_bedrock(prompt)
        
        return {
            'average_score': average_score,
            'total_reviews': len(reviews),
            'star_distribution': distribution,
            'ai_summary': ai_summary
        }
    
    def _get_product_data(self, product_id):
        """Busca dados do produto"""
        try:
            response = self.products_table.get_item(Key={'product_id': product_id})
            return response.get('Item', {})
        except:
            return {}
    
    def _call_bedrock(self, prompt):
        """Call Bedrock for analysis"""
        try:
            response = self.bedrock.invoke_model(
                modelId='anthropic.claude-3-haiku-20240307-v1:0',
                body=json.dumps({
                    'anthropic_version': 'bedrock-2023-05-31',
                    'max_tokens': 1000,
                    'messages': [{'role': 'user', 'content': prompt}]
                })
            )
            
            result = json.loads(response['body'].read())
            return json.loads(result['content'][0]['text'])
        except Exception as e:
            return {'error': f'AI analysis failed: {str(e)}'}
    
    def _success_response(self, data):
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(data, default=self._decimal_default)
        }
    
    def _decimal_default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        raise TypeError
    
    def _error_response(self, status_code, message):
        return {
            'statusCode': status_code,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': message}, default=self._decimal_default)
        }

def lambda_handler(event, context):
    api = ReviewAPI()
    
    path = event.get('path', '')
    method = event.get('httpMethod', 'GET')
    
    # Roteamento
    if path == '/reviews' and method == 'POST':
        return api.create_review(event)
    
    elif path == '/admin/reviews' and method == 'GET':
        return api.list_reviews_admin(event)
    
    elif path == '/store/reviews' and method == 'GET':
        return api.list_reviews_store(event)
    
    elif path == '/products' and method == 'GET':
        return api.list_products(event)
    
    else:
        return api._error_response(404, 'Endpoint not found')