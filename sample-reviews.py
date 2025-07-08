import boto3
import json
from datetime import datetime
import uuid

# Script para popular reviews de exemplo
def populate_sample_reviews():
    dynamodb = boto3.resource('dynamodb')
    reviews_table = dynamodb.Table('retail-hackaton-reviews')
    
    sample_reviews = [
        # iPhone 13 - PROD-002
        {
            'product_id': 'PROD-002',
            'score': 5,
            'description': 'Produto excelente, chegou rapidamente e bem embalado. Bateria dura o dia todo.'
        },
        {
            'product_id': 'PROD-002', 
            'score': 2,
            'description': 'Tela chegou com risco, embalagem estava danificada. Entrega atrasou 3 dias.'
        },
        {
            'product_id': 'PROD-002',
            'score': 4,
            'description': 'Bom produto mas esquenta muito durante jogos. Atendimento foi prestativo.'
        },
        {
            'product_id': 'PROD-002',
            'score': 1,
            'description': 'Produto veio com defeito na câmera. Tentei contato mas ninguém responde.'
        },
        
        # Samsung Galaxy A54 - PROD-001
        {
            'product_id': 'PROD-001',
            'score': 4,
            'description': 'Ótimo custo benefício, tela bonita. Só a bateria que poderia durar mais.'
        },
        {
            'product_id': 'PROD-001',
            'score': 3,
            'description': 'Produto ok, mas chegou com arranhão na traseira. Entrega foi no prazo.'
        },
        {
            'product_id': 'PROD-001',
            'score': 5,
            'description': 'Superou expectativas! Câmera muito boa e sistema fluido.'
        },
        {
            'product_id': 'PROD-001',
            'score': 2,
            'description': 'Travou várias vezes, parece ter problema de software. Suporte técnico demorou para responder.'
        },
        
        # Smart TV Samsung - PROD-003
        {
            'product_id': 'PROD-003',
            'score': 5,
            'description': 'TV incrível, imagem perfeita. Instalação foi rápida e sem problemas.'
        },
        {
            'product_id': 'PROD-003',
            'score': 1,
            'description': 'Chegou com tela quebrada, embalagem inadequada. Transportadora foi negligente.'
        },
        {
            'product_id': 'PROD-003',
            'score': 4,
            'description': 'Boa TV mas o controle remoto veio sem bateria. Som poderia ser melhor.'
        },
        {
            'product_id': 'PROD-003',
            'score': 3,
            'description': 'Produto bom mas demorou 2 semanas para chegar. Sistema smart é lento às vezes.'
        }
    ]
    
    for review in sample_reviews:
        review_id = str(uuid.uuid4())
        
        reviews_table.put_item(
            Item={
                'review_id': review_id,
                'product_id': review['product_id'],
                'score': review['score'],
                'description': review['description'],
                'created_at': datetime.now().isoformat()
            }
        )
        
        print(f"Review inserido: {review_id}")

if __name__ == "__main__":
    populate_sample_reviews()
    print("Reviews de exemplo inseridos com sucesso!")