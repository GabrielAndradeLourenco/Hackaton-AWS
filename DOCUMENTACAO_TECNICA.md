# Documentação Técnica - Retail Content Generator

## Visão Geral

Sistema de geração automática de conteúdo para retail usando Amazon Bedrock, desenvolvido para hackathon AWS. A solução permite gerar banners e posts para redes sociais com aprovação de conteúdo e distribuição via API pública.

## Arquitetura

### Componentes Principais

- **3 Lambda Functions**: Geração, aprovação e API pública
- **2 API Gateways**: Admin (privada) e Public (pública)
- **3 DynamoDB Tables**: products, contents, approvals
- **S3 + CloudFront**: Armazenamento e CDN para assets
- **SNS**: Notificações de aprovação
- **Amazon Bedrock**: Geração de conteúdo via Claude

### Fluxo de Dados

1. **Geração**: Admin → API → Lambda → Bedrock → DynamoDB/S3
2. **Aprovação**: Admin → API → Lambda → DynamoDB → SNS
3. **Consumo**: E-commerce → API Pública → Lambda → DynamoDB

## APIs

### Admin API (Privada)

**Base URL**: `https://{api-id}.execute-api.{region}.amazonaws.com/prod`

#### POST /generate
Gera conteúdo para um produto específico.

**Request:**
```json
{
  "product_id": "123",
  "type": "banner"
}
```

**Response:**
```json
{
  "content_id": "uuid-123",
  "text": "Texto gerado pelo Bedrock",
  "status": "pending"
}
```

#### PUT /approve/{id}
Aprova ou rejeita conteúdo gerado.

**Request:**
```json
{
  "action": "approve",
  "comment": "Aprovado para campanha"
}
```

**Response:**
```json
{
  "approval_id": "uuid-456",
  "content_id": "uuid-123",
  "status": "approved",
  "message": "Content approved successfully"
}
```

### Public API (Pública)

**Base URL**: `https://{api-id}.execute-api.{region}.amazonaws.com/prod`

#### GET /products
Retorna conteúdo aprovado para e-commerce.

**Query Parameters:**
- `category` (opcional): Filtrar por categoria
- `type` (opcional): Tipo de conteúdo (banner, social_post)

**Response:**
```json
{
  "contents": [
    {
      "content_id": "uuid-123",
      "product": {
        "product_id": "123",
        "name": "iPhone 15",
        "category": "smartphones"
      },
      "text": "Texto aprovado",
      "type": "banner",
      "image_url": "https://cdn.domain.com/uuid-123.jpg",
      "created_at": "2024-01-01T10:00:00Z"
    }
  ],
  "count": 1
}
```

## Modelo de Dados

### Products Table
```json
{
  "product_id": "123",
  "name": "iPhone 15 Pro",
  "category": "smartphones",
  "description": "Último iPhone",
  "price": 1299.99,
  "created_at": "2024-01-01T10:00:00Z",
  "updated_at": "2024-01-01T10:00:00Z"
}
```

### Contents Table
```json
{
  "content_id": "uuid-123",
  "product_id": "123",
  "type": "banner",
  "text": "Texto gerado",
  "image_url": "https://cdn.domain.com/image.jpg",
  "status": "approved",
  "created_at": "2024-01-01T10:00:00Z",
  "updated_at": "2024-01-01T10:00:00Z"
}
```

### Approvals Table
```json
{
  "approval_id": "uuid-456",
  "content_id": "uuid-123",
  "status": "approved",
  "comment": "Aprovado!",
  "approver_id": "admin-user",
  "created_at": "2024-01-01T10:00:00Z"
}
```

## Índices DynamoDB

### Products
- **PK**: product_id
- **GSI**: category-index, name-index, description-index, created-at-index, updated-at-index

### Contents
- **PK**: content_id
- **GSI**: product-index, type-index, text-index, image-url-index, status-index, contents-created-at-index, contents-updated-at-index

### Approvals
- **PK**: approval_id
- **GSI**: content-index, approvals-status-index, comment-index, approver-id-index, approvals-created-at-index, approvals-updated-at-index

## Segurança

### IAM Permissions
- **Lambda**: DynamoDB (CRUD), S3 (Read/Write), Bedrock (InvokeModel), SNS (Publish)
- **API Gateway**: Lambda invoke permissions
- **S3**: Acesso público para leitura de assets

### Autenticação
- Admin API: Sem autenticação (para hackathon)
- Public API: Sem autenticação (acesso público)

## Deploy

### Pré-requisitos
```bash
# AWS CLI configurado
aws configure

# Terraform instalado
terraform --version
```

### Comandos
```bash
cd infra-hackaton

# Inicializar
terraform init

# Planejar
terraform plan

# Aplicar
terraform apply

# Criar pacotes Lambda
cd lambda
zip content-generation.zip content-generation.py
zip approval-handler.zip approval-handler.py
zip public-api.zip public-api.py
```

### Variáveis
```hcl
# variables.tf
variable "aws_region" {
  default = "us-west-2"
}

variable "project_name" {
  default = "retail-hackaton"
}
```

## Monitoramento

### CloudWatch Logs
- `/aws/lambda/retail-hackaton-content-generation`
- `/aws/lambda/retail-hackaton-approval-handler`
- `/aws/lambda/retail-hackaton-public-api`

### Métricas
- Lambda: Duration, Errors, Invocations
- API Gateway: Count, Latency, 4XXError, 5XXError
- DynamoDB: ConsumedReadCapacityUnits, ConsumedWriteCapacityUnits

## Limitações

### Hackathon Scope
- Sem autenticação robusta
- Sem rate limiting
- Sem validação de entrada avançada
- Sem testes automatizados

### Produção Considerations
- Implementar Cognito/JWT
- Adicionar WAF
- Configurar alarmes CloudWatch
- Implementar CI/CD
- Adicionar testes unitários

## Custos Estimados

### Por 1000 Gerações/Mês
- **Lambda**: ~$0.20
- **DynamoDB**: ~$1.25
- **API Gateway**: ~$3.50
- **Bedrock**: ~$15.00 (Claude 3 Haiku)
- **S3 + CloudFront**: ~$0.50

**Total**: ~$20.45/mês

## Troubleshooting

### Erros Comuns
1. **Lambda Timeout**: Aumentar timeout para geração de conteúdo
2. **DynamoDB Throttling**: Verificar capacidade provisionada
3. **Bedrock Access**: Verificar permissões IAM
4. **S3 Upload**: Verificar políticas de bucket

### Logs Úteis
```bash
# Lambda logs
aws logs tail /aws/lambda/retail-hackaton-content-generation --follow

# API Gateway logs
aws logs tail API-Gateway-Execution-Logs_{api-id}/prod --follow
```

## Próximos Passos

### Melhorias Técnicas
- [ ] Implementar autenticação
- [ ] Adicionar validação de entrada
- [ ] Configurar monitoramento avançado
- [ ] Implementar cache Redis
- [ ] Adicionar testes automatizados

### Funcionalidades
- [ ] Geração de imagens via DALL-E
- [ ] Integração com trends do Google
- [ ] Dashboard de analytics
- [ ] Agendamento de posts
- [ ] A/B testing de conteúdo