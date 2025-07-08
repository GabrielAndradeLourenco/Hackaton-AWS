import json
import boto3
from datetime import datetime
import uuid

class ReviewAnalyzer:
    def __init__(self):
        self.dynamodb = boto3.resource('dynamodb')
        self.bedrock = boto3.client('bedrock-runtime')
        self.reviews_table = self.dynamodb.Table('retail-hackaton-reviews')
        self.insights_table = self.dynamodb.Table('retail-hackaton-insights')
        self.products_table = self.dynamodb.Table('retail-hackaton-products')
    
    def analyze_product_reviews(self, product_id):
        """Analisa todos os reviews de um produto e gera insights"""
        
        # 1. Busca reviews do produto
        reviews = self._get_product_reviews(product_id)
        
        if not reviews:
            return {"error": "Nenhum review encontrado"}
        
        # 2. Busca dados do produto
        product = self._get_product_data(product_id)
        
        # 3. Gera análise com Bedrock
        insights = self._generate_insights(reviews, product)
        
        # 4. Salva insights no DynamoDB
        insight_id = self._save_insights(product_id, insights)
        
        return {
            "insight_id": insight_id,
            "product_id": product_id,
            "total_reviews": len(reviews),
            "insights": insights
        }
    
    def _get_product_reviews(self, product_id):
        """Busca todos os reviews de um produto"""
        try:
            response = self.reviews_table.query(
                IndexName='product-index',
                KeyConditionExpression='product_id = :pid',
                ExpressionAttributeValues={':pid': product_id}
            )
            return response['Items']
        except Exception as e:
            print(f"Erro ao buscar reviews: {e}")
            return []
    
    def _get_product_data(self, product_id):
        """Busca dados do produto"""
        try:
            response = self.products_table.get_item(Key={'product_id': product_id})
            return response.get('Item', {})
        except Exception as e:
            print(f"Erro ao buscar produto: {e}")
            return {}
    
    def _generate_insights(self, reviews, product):
        """Gera insights usando Bedrock"""
        
        # Prepara contexto dos reviews
        reviews_text = "\n".join([
            f"Score: {r.get('score', 'N/A')}/5 - {r.get('description', '')}"
            for r in reviews
        ])
        
        prompt = f"""
        Analise os seguintes reviews do produto "{product.get('name', 'Produto')}" 
        da categoria "{product.get('category', 'N/A')}":

        REVIEWS:
        {reviews_text}

        Gere um relatório estruturado em JSON com:
        1. "problemas_fabricacao": Lista dos principais problemas de fabricação mencionados
        2. "problemas_entrega": Problemas relacionados à entrega/logística
        3. "problemas_atendimento": Issues com atendimento ao cliente
        4. "pontos_positivos": Principais elogios dos clientes
        5. "score_medio": Média das avaliações
        6. "recomendacoes": 3 ações prioritárias para melhorar o produto/serviço
        7. "urgencia": "alta", "media" ou "baixa" baseado na gravidade dos problemas

        Responda APENAS com o JSON válido, sem explicações adicionais.
        """
        
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
            insights_text = result['content'][0]['text']
            
            # Parse do JSON retornado
            return json.loads(insights_text)
            
        except Exception as e:
            print(f"Erro na análise: {e}")
            return {
                "error": "Falha na análise",
                "problemas_fabricacao": [],
                "problemas_entrega": [],
                "problemas_atendimento": [],
                "pontos_positivos": [],
                "score_medio": 0,
                "recomendacoes": [],
                "urgencia": "baixa"
            }
    
    def _save_insights(self, product_id, insights):
        """Salva insights no DynamoDB"""
        insight_id = str(uuid.uuid4())
        
        try:
            self.insights_table.put_item(
                Item={
                    'insight_id': insight_id,
                    'product_id': product_id,
                    'category': insights.get('urgencia', 'baixa'),
                    'insights': insights,
                    'created_at': datetime.now().isoformat()
                }
            )
            return insight_id
        except Exception as e:
            print(f"Erro ao salvar insights: {e}")
            return None
    
    def get_dashboard_data(self):
        """Retorna dados para dashboard executivo"""
        try:
            # Busca insights mais recentes
            response = self.insights_table.scan(
                Limit=50,
                ScanFilter={
                    'created_at': {
                        'AttributeValueList': [
                            (datetime.now().date() - datetime.timedelta(days=30)).isoformat()
                        ],
                        'ComparisonOperator': 'GT'
                    }
                }
            )
            
            insights = response['Items']
            
            # Agrupa por urgência
            urgencia_count = {'alta': 0, 'media': 0, 'baixa': 0}
            problemas_comuns = {}
            
            for insight in insights:
                urgencia = insight.get('category', 'baixa')
                urgencia_count[urgencia] += 1
                
                # Conta problemas mais comuns
                insight_data = insight.get('insights', {})
                for problema in insight_data.get('problemas_fabricacao', []):
                    problemas_comuns[problema] = problemas_comuns.get(problema, 0) + 1
            
            return {
                'total_produtos_analisados': len(insights),
                'distribuicao_urgencia': urgencia_count,
                'problemas_mais_comuns': dict(sorted(problemas_comuns.items(), 
                                                   key=lambda x: x[1], reverse=True)[:5]),
                'insights_recentes': insights[:10]
            }
            
        except Exception as e:
            print(f"Erro no dashboard: {e}")
            return {}

# Lambda handler
def lambda_handler(event, context):
    analyzer = ReviewAnalyzer()
    
    # Rota baseada no path
    path = event.get('path', '')
    method = event.get('httpMethod', 'GET')
    
    if path == '/analyze' and method == 'POST':
        # Análise de produto específico
        body = json.loads(event.get('body', '{}'))
        product_id = body.get('product_id')
        
        if not product_id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'product_id obrigatório'})
            }
        
        result = analyzer.analyze_product_reviews(product_id)
        
        return {
            'statusCode': 200,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps(result)
        }
    
    elif path == '/dashboard' and method == 'GET':
        # Dashboard executivo
        dashboard_data = analyzer.get_dashboard_data()
        
        return {
            'statusCode': 200,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps(dashboard_data)
        }
    
    else:
        return {
            'statusCode': 404,
            'body': json.dumps({'error': 'Endpoint não encontrado'})
        }