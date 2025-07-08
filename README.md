# Marketing Image Generator - Backend

Sistema backend para geração de imagens de marketing baseado em tendências web e dados internos da loja.

## Arquitetura

### Node.js Express API
- **Framework**: Express.js com TypeScript
- **Estrutura**: Controllers, Services, Routes e Models
- **Middleware**: CORS, JSON parsing

### Lambda Functions (Serverless)
- **Generator**: Inicia processo assíncrono de geração
- **Worker**: Processa geração usando Amazon Bedrock
- **Approval**: Aprova conteúdo e notifica via SNS
- **Status**: Consulta status dos jobs
- **Public**: Serve conteúdo aprovado publicamente

### AWS Services
- **DynamoDB**: Armazenamento de dados (Content, Trends)
- **S3**: Storage de imagens geradas
- **Bedrock**: IA para geração de imagens
- **SNS**: Notificações de aprovação
- **Lambda**: Processamento serverless
- **API Gateway**: Endpoints REST

## Estrutura do Projeto

```
/
├── src/                          # Node.js Express API
│   ├── api/
│   │   ├── controllers/
│   │   ├── routes/
│   │   └── services/
│   ├── models/
│   ├── app.ts
│   └── server.ts
├── lambda/                       # AWS Lambda Functions
│   ├── generator/
│   ├── worker/
│   ├── approval/
│   ├── status/
│   ├── public/
│   └── deployment-config.md
├── package.json
├── tsconfig.json
└── .env.example
```

## API Endpoints

### Content Generation
- `POST /api/v1/content/generate` - Inicia geração assíncrona
- `GET /api/v1/content/status/{contentId}` - Status do job
- `PUT /api/v1/content/{contentId}/approve` - Aprova conteúdo
- `GET /api/v1/public/content/{campaign}` - Conteúdo aprovado

### Express API (Development)
- `GET /api/v1/trends` - Tendências disponíveis
- `POST /api/v1/products` - Adicionar produtos
- `GET /api/v1/products` - Listar produtos
- `POST /api/v1/images/generate` - Gerar imagens

## Fluxo de Trabalho

1. **Geração**: Cliente faz POST para `/content/generate`
2. **Processamento**: Worker Lambda usa Bedrock para gerar imagem
3. **Armazenamento**: Imagem salva no S3
4. **Aprovação**: Status muda para "awaiting_approval"
5. **Aprovação Manual**: PUT para `/approve` endpoint
6. **Notificação**: SNS notifica aprovação
7. **Publicação**: Conteúdo disponível via API pública

## Setup Rápido

```bash
# Instalar dependências
npm install

# Configurar ambiente
cp .env.example .env

# Desenvolvimento
npm run dev

# Build
npm run build
```

## Próximos Passos

1. Deploy das Lambda functions
2. Configuração do DynamoDB com GSI
3. Setup do S3 bucket
4. Configuração do Bedrock
5. Criação do tópico SNS
6. Deploy do API Gateway

---

**Hackathon AWS - Sistema de Geração de Imagens de Marketing**