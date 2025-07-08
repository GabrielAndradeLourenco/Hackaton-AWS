import json
import boto3
from PIL import Image, ImageDraw, ImageFont
import requests
from io import BytesIO

class HybridImageGenerator:
    def __init__(self):
        self.s3 = boto3.client('s3')
        self.bedrock = boto3.client('bedrock-runtime')
        self.template_bucket = 'your-templates-bucket'
    
    def generate_professional_banner(self, product_data):
        """Gera banner profissional usando template + IA"""
        
        # 1. IA analisa produto e escolhe template
        template_choice = self._ai_select_template(product_data)
        
        # 2. Baixa template do S3
        template_image = self._download_template(template_choice['template_id'])
        
        # 3. IA gera texto personalizado
        ai_text = self._generate_marketing_text(product_data)
        
        # 4. Compõe imagem final
        final_image = self._compose_banner(
            template_image, 
            product_data, 
            ai_text,
            template_choice['layout']
        )
        
        return final_image
    
    def _ai_select_template(self, product_data):
        """IA escolhe melhor template baseado no produto"""
        prompt = f"""
        Produto: {product_data['name']}
        Categoria: {product_data['category']}
        Preço: R$ {product_data.get('price', 'N/A')}
        
        Escolha o melhor template:
        1. modern_tech - Para eletrônicos modernos
        2. elegant_fashion - Para moda e acessórios  
        3. bold_sports - Para esportes e fitness
        4. minimal_home - Para casa e decoração
        5. vibrant_kids - Para produtos infantis
        
        Responda apenas com o ID do template e layout sugerido.
        """
        
        response = self.bedrock.invoke_model(
            modelId='anthropic.claude-3-haiku-20240307-v1:0',
            body=json.dumps({
                'anthropic_version': 'bedrock-2023-05-31',
                'max_tokens': 100,
                'messages': [{'role': 'user', 'content': prompt}]
            })
        )
        
        # Parse response e retorna escolha
        result = json.loads(response['body'].read())
        return {
            'template_id': 'modern_tech',  # Simplificado para demo
            'layout': 'center_focus'
        }
    
    def _generate_marketing_text(self, product_data):
        """Gera texto de marketing personalizado"""
        prompt = f"""
        Crie um texto de marketing impactante para:
        Produto: {product_data['name']}
        Categoria: {product_data['category']}
        
        Requisitos:
        - Máximo 2 linhas
        - Linguagem persuasiva
        - Destaque o principal benefício
        - Tom brasileiro e moderno
        
        Exemplo: "Tecnologia que transforma seu dia a dia"
        """
        
        response = self.bedrock.invoke_model(
            modelId='anthropic.claude-3-haiku-20240307-v1:0',
            body=json.dumps({
                'anthropic_version': 'bedrock-2023-05-31',
                'max_tokens': 150,
                'messages': [{'role': 'user', 'content': prompt}]
            })
        )
        
        result = json.loads(response['body'].read())
        return result['content'][0]['text'].strip()
    
    def _download_template(self, template_id):
        """Baixa template do S3"""
        try:
            response = self.s3.get_object(
                Bucket=self.template_bucket,
                Key=f'templates/{template_id}.png'
            )
            return Image.open(BytesIO(response['Body'].read()))
        except:
            # Fallback para template padrão
            return self._create_default_template()
    
    def _compose_banner(self, template, product_data, ai_text, layout):
        """Compõe banner final"""
        # Cria cópia do template
        banner = template.copy()
        draw = ImageDraw.Draw(banner)
        
        # Carrega fonte
        try:
            font_title = ImageFont.truetype("arial.ttf", 48)
            font_subtitle = ImageFont.truetype("arial.ttf", 32)
        except:
            font_title = ImageFont.load_default()
            font_subtitle = ImageFont.load_default()
        
        # Adiciona nome do produto
        draw.text((50, 50), product_data['name'], 
                 fill=(255, 255, 255), font=font_title)
        
        # Adiciona texto de marketing
        draw.text((50, 120), ai_text, 
                 fill=(255, 255, 255), font=font_subtitle)
        
        # Adiciona preço se disponível
        if 'price' in product_data:
            price_text = f"R$ {product_data['price']}"
            draw.text((50, 180), price_text, 
                     fill=(255, 215, 0), font=font_title)
        
        return banner
    
    def _create_default_template(self):
        """Cria template padrão caso não encontre no S3"""
        img = Image.new('RGB', (800, 400), color=(33, 150, 243))
        return img