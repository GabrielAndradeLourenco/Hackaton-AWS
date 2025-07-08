# Backend - Marketing Image Generator

Backend Node.js com Express API e Lambda Functions para geração assíncrona de imagens.

## Tecnologias

- **Node.js** + **TypeScript**
- **Express.js** para API REST
- **AWS Lambda** para processamento serverless
- **AWS SDK v3** para integração com serviços AWS

## Estrutura

```
backend/
├── src/                    # Express API
│   ├── api/
│   │   ├── controllers/
│   │   ├── routes/
│   │   └── services/
│   └── models/
└── lambda/                 # Lambda Functions
    ├── generator/          # Inicia geração
    ├── worker/             # Processa com Bedrock
    ├── approval/           # Aprova conteúdo
    ├── status/             # Consulta status
    └── public/             # API pública
```

## Setup

```bash
npm install
cp .env.example .env
npm run dev
```

## API Endpoints

- `POST /api/v1/content/generate` - Gerar imagem
- `GET /api/v1/content/status/{id}` - Status
- `PUT /api/v1/content/{id}/approve` - Aprovar
- `GET /api/v1/public/content/{campaign}` - Público