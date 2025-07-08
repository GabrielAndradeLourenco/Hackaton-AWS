terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# DynamoDB Tables
resource "aws_dynamodb_table" "products" {
  name           = "${var.project_name}-products"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "product_id"

  attribute {
    name = "product_id"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  attribute {
    name = "description"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  attribute {
    name = "updated_at"
    type = "S"
  }

  attribute {
    name = "price"
    type = "N"
  }

  global_secondary_index {
    name            = "category-index"
    hash_key        = "category"
    projection_type = "ALL"
  }


  global_secondary_index {
    name            = "price-index"
    hash_key        = "price"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "name-index"
    hash_key        = "name"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "description-index"
    hash_key        = "description"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "created-at-index"
    hash_key        = "created_at"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "updated-at-index"
    hash_key        = "updated_at"
    projection_type = "ALL"
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "reviews" {
  name           = "${var.project_name}-reviews"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "review_id"

  attribute {
    name = "review_id"
    type = "S"
  }

  attribute {
    name = "product_id"
    type = "S"
  }

  attribute {
    name = "description"
    type = "S"
  }

  attribute {
    name = "score"
    type = "N"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  attribute {
    name = "user_name"
    type = "S"
  }

  global_secondary_index {
    name            = "product-index"
    hash_key        = "product_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "description-index"
    hash_key        = "description"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "score-index"
    hash_key        = "score"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "user_name-index"
    hash_key        = "user_name"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "created-at-index"
    hash_key        = "created_at"
    projection_type = "ALL"
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "insights" {
  name           = "${var.project_name}-insights"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "insight_id"

  attribute {
    name = "insight_id"
    type = "S"
  }

  attribute {
    name = "product_id"
    type = "S"
  }

  attribute {
    name = "category"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  global_secondary_index {
    name            = "product-index"
    hash_key        = "product_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "category-index"
    hash_key        = "category"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "created-at-index"
    hash_key        = "created_at"
    projection_type = "ALL"
  }

  tags = var.tags
}

# Produtos do catálogo
resource "aws_dynamodb_table_item" "product_1" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-001" }
    name = { S = "Smartphone Samsung Galaxy A54 128GB" }
    description = { S = "Celular Samsung Galaxy A54 5G com 128GB de armazenamento" }
    category = { S = "Smartphones" }
    price = { N = "1299.99" }
  })
}

resource "aws_dynamodb_table_item" "product_2" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-002" }
    name = { S = "Apple iPhone 13 128GB" }
    description = { S = "iPhone 13 com tela Super Retina XDR e 128GB de espaço" }
    category = { S = "Smartphones" }
    price = { N = "3999.99" }
  })
}

resource "aws_dynamodb_table_item" "product_3" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-003" }
    name = { S = "Smart TV Samsung 50\" 4K" }
    description = { S = "TV Crystal UHD 50\" com Alexa integrada" }
    category = { S = "TVs" }
    price = { N = "2199.99" }
  })
}

resource "aws_dynamodb_table_item" "product_4" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-004" }
    name = { S = "Fone de Ouvido JBL Tune 510BT" }
    description = { S = "Fone de ouvido Bluetooth on-ear com até 40h de bateria" }
    category = { S = "Áudio" }
    price = { N = "199.99" }
  })
}

resource "aws_dynamodb_table_item" "product_5" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-005" }
    name = { S = "Notebook Dell Inspiron 15 i5 512GB SSD" }
    description = { S = "Notebook Dell com processador Intel Core i5, 8GB RAM" }
    category = { S = "Notebooks" }
    price = { N = "2899.99" }
  })
}

resource "aws_dynamodb_table_item" "product_6" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-006" }
    name = { S = "Echo Dot 5ª Geração" }
    description = { S = "Alto-falante inteligente com Alexa integrada" }
    category = { S = "Casa inteligente" }
    price = { N = "299.99" }
  })
}

resource "aws_dynamodb_table_item" "product_7" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-007" }
    name = { S = "Kindle Paperwhite 8GB" }
    description = { S = "Leitor digital Kindle com luz ajustável e resistência à água" }
    category = { S = "Leitores digitais" }
    price = { N = "549.99" }
  })
}

resource "aws_dynamodb_table_item" "product_8" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-008" }
    name = { S = "Smartwatch Apple Watch SE 40mm" }
    description = { S = "Relógio inteligente com rastreamento de atividades e saúde" }
    category = { S = "Wearables" }
    price = { N = "1899.99" }
  })
}

resource "aws_dynamodb_table_item" "product_9" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-009" }
    name = { S = "Xiaomi Redmi Note 12 256GB" }
    description = { S = "Smartphone Xiaomi com tela AMOLED 120Hz" }
    category = { S = "Smartphones" }
    price = { N = "899.99" }
  })
}

resource "aws_dynamodb_table_item" "product_10" {
  table_name = aws_dynamodb_table.products.name
  hash_key   = aws_dynamodb_table.products.hash_key

  item = jsonencode({
    product_id = { S = "PROD-010" }
    name = { S = "Nintendo Switch OLED 32GB" }
    description = { S = "Console portátil com tela OLED de 7\" e Joy-Con" }
    category = { S = "Games" }
    price = { N = "2499.99" }
  })
}

# Reviews de exemplo
resource "aws_dynamodb_table_item" "review_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key

  item = jsonencode({
    review_id = { S = "REV-001" }
    product_id = { S = "PROD-001" }
    score = { N = "4" }
    description = { S = "Celular muito bom, câmera excelente e performance ótima. Único problema é que a bateria não dura o dia todo com uso intenso." }
    created_at = { S = "2024-02-01T09:30:00Z" }
    user_name = { S = "João Silva" }
  })
}

resource "aws_dynamodb_table_item" "review_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key

  item = jsonencode({
    review_id = { S = "REV-002" }
    product_id = { S = "PROD-001" }
    score = { N = "3" }
    description = { S = "Produto ok, mas esperava mais da bateria. Preciso carregar 2x por dia. Fora isso, funciona bem." }
    created_at = { S = "2024-02-02T14:15:00Z" }
    user_name = { S = "Maria Santos" }
  })
}

resource "aws_dynamodb_table_item" "review_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key

  item = jsonencode({
    review_id = { S = "REV-003" }
    product_id = { S = "PROD-002" }
    score = { N = "5" }
    description = { S = "iPhone perfeito! Sistema muito fluido, câmera incrível. Só acho que a interface poderia ser mais customizável, mas no geral é excelente." }
    created_at = { S = "2024-02-03T11:45:00Z" }
    user_name = { S = "Pedro Costa" }
  })
}

resource "aws_dynamodb_table_item" "review_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key

  item = jsonencode({
    review_id = { S = "REV-004" }
    product_id = { S = "PROD-003" }
    score = { N = "4" }
    description = { S = "TV muito boa, cores vivas e som decente. A qualidade de imagem poderia ser melhor em ambientes muito claros, mas no geral estou satisfeita." }
    created_at = { S = "2024-02-04T16:20:00Z" }
    user_name = { S = "Ana Oliveira" }
  })
}

resource "aws_dynamodb_table_item" "review_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key

  item = jsonencode({
    review_id = { S = "REV-005" }
    product_id = { S = "PROD-004" }
    score = { N = "5" }
    description = { S = "Fone excelente! Som muito bom e super confortável para usar por horas. Recomendo muito!" }
    created_at = { S = "2024-02-05T10:00:00Z" }
    user_name = { S = "Carlos Lima" }
  })
}

resource "aws_dynamodb_table_item" "review_6" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key

  item = jsonencode({
    review_id = { S = "REV-006" }
    product_id = { S = "PROD-005" }
    score = { N = "2" }
    description = { S = "Notebook com boa configuração, mas a performance deixa a desejar para jogos e programas pesados. Trava muito." }
    created_at = { S = "2024-02-06T11:20:00Z" }
    user_name = { S = "Roberto Alves" }
  })
}

# Reviews para PROD-001 (Samsung Galaxy A54)
resource "aws_dynamodb_table_item" "review_001_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-001-1" }
    product_id = { S = "PROD-001" }
    score = { N = "4" }
    description = { S = "Celular muito bom, câmera excelente. Único problema é a bateria que não dura o dia todo." }
    created_at = { S = "2024-02-01T09:30:00Z" }
    user_name = { S = "João Silva" }
  })
}

resource "aws_dynamodb_table_item" "review_001_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-001-2" }
    product_id = { S = "PROD-001" }
    score = { N = "3" }
    description = { S = "Produto ok, mas a bateria deixa a desejar. Preciso carregar 2x por dia." }
    created_at = { S = "2024-02-02T14:15:00Z" }
    user_name = { S = "Maria Santos" }
  })
}

resource "aws_dynamodb_table_item" "review_001_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-001-3" }
    product_id = { S = "PROD-001" }
    score = { N = "5" }
    description = { S = "Excelente custo-benefício! Tela linda e sistema rápido. Recomendo!" }
    created_at = { S = "2024-02-03T11:20:00Z" }
    user_name = { S = "Carlos Mendes" }
  })
}

resource "aws_dynamodb_table_item" "review_001_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-001-4" }
    product_id = { S = "PROD-001" }
    score = { N = "4" }
    description = { S = "Bom smartphone, mas esquenta um pouco durante jogos pesados." }
    created_at = { S = "2024-02-04T16:45:00Z" }
    user_name = { S = "Ana Costa" }
  })
}

resource "aws_dynamodb_table_item" "review_001_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-001-5" }
    product_id = { S = "PROD-001" }
    score = { N = "2" }
    description = { S = "Decepcionante. A bateria é muito fraca e o carregamento é lento." }
    created_at = { S = "2024-02-05T08:30:00Z" }
    user_name = { S = "Roberto Lima" }
  })
}

# Reviews para PROD-002 (iPhone 13)
resource "aws_dynamodb_table_item" "review_002_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-002-1" }
    product_id = { S = "PROD-002" }
    score = { N = "5" }
    description = { S = "iPhone perfeito! Sistema fluido, câmera incrível. Vale cada centavo." }
    created_at = { S = "2024-02-06T10:15:00Z" }
    user_name = { S = "Pedro Costa" }
  })
}

resource "aws_dynamodb_table_item" "review_002_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-002-2" }
    product_id = { S = "PROD-002" }
    score = { N = "4" }
    description = { S = "Muito bom, mas a interface poderia ser mais customizável." }
    created_at = { S = "2024-02-07T13:20:00Z" }
    user_name = { S = "Lucia Ferreira" }
  })
}

resource "aws_dynamodb_table_item" "review_002_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-002-3" }
    product_id = { S = "PROD-002" }
    score = { N = "5" }
    description = { S = "Qualidade Apple como sempre. Bateria dura o dia todo." }
    created_at = { S = "2024-02-08T15:30:00Z" }
    user_name = { S = "Marcos Oliveira" }
  })
}

resource "aws_dynamodb_table_item" "review_002_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-002-4" }
    product_id = { S = "PROD-002" }
    score = { N = "3" }
    description = { S = "Bom produto, mas muito caro para o que oferece." }
    created_at = { S = "2024-02-09T09:45:00Z" }
    user_name = { S = "Fernanda Silva" }
  })
}

resource "aws_dynamodb_table_item" "review_002_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-002-5" }
    product_id = { S = "PROD-002" }
    score = { N = "4" }
    description = { S = "Excelente câmera e performance. Só falta mais opções de personalização." }
    created_at = { S = "2024-02-10T12:00:00Z" }
    user_name = { S = "Diego Santos" }
  })
}

# Reviews para PROD-003 (Smart TV Samsung)
resource "aws_dynamodb_table_item" "review_003_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-003-1" }
    product_id = { S = "PROD-003" }
    score = { N = "4" }
    description = { S = "TV muito boa, cores vivas. A qualidade de imagem poderia ser melhor em ambientes claros." }
    created_at = { S = "2024-02-11T14:20:00Z" }
    user_name = { S = "Ana Oliveira" }
  })
}

resource "aws_dynamodb_table_item" "review_003_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-003-2" }
    product_id = { S = "PROD-003" }
    score = { N = "5" }
    description = { S = "Perfeita! Imagem 4K incrível e a Alexa integrada é muito útil." }
    created_at = { S = "2024-02-12T16:30:00Z" }
    user_name = { S = "Ricardo Alves" }
  })
}

resource "aws_dynamodb_table_item" "review_003_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-003-3" }
    product_id = { S = "PROD-003" }
    score = { N = "3" }
    description = { S = "Boa TV, mas o som poderia ser mais potente. Precisei comprar soundbar." }
    created_at = { S = "2024-02-13T11:15:00Z" }
    user_name = { S = "Juliana Rocha" }
  })
}

resource "aws_dynamodb_table_item" "review_003_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-003-4" }
    product_id = { S = "PROD-003" }
    score = { N = "4" }
    description = { S = "Excelente custo-benefício. Interface intuitiva e boa conectividade." }
    created_at = { S = "2024-02-14T18:45:00Z" }
    user_name = { S = "Paulo Martins" }
  })
}

resource "aws_dynamodb_table_item" "review_003_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-003-5" }
    product_id = { S = "PROD-003" }
    score = { N = "2" }
    description = { S = "Decepcionante. A imagem fica muito escura em filmes e o controle é lento." }
    created_at = { S = "2024-02-15T20:10:00Z" }
    user_name = { S = "Carla Nunes" }
  })
}

# Reviews para PROD-004 (JBL Fone)
resource "aws_dynamodb_table_item" "review_004_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-004-1" }
    product_id = { S = "PROD-004" }
    score = { N = "5" }
    description = { S = "Fone excelente! Som muito bom e super confortável para usar por horas." }
    created_at = { S = "2024-02-16T09:30:00Z" }
    user_name = { S = "Carlos Lima" }
  })
}

resource "aws_dynamodb_table_item" "review_004_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-004-2" }
    product_id = { S = "PROD-004" }
    score = { N = "4" }
    description = { S = "Ótimo fone, mas às vezes a conexão Bluetooth falha." }
    created_at = { S = "2024-02-17T14:20:00Z" }
    user_name = { S = "Beatriz Costa" }
  })
}

resource "aws_dynamodb_table_item" "review_004_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-004-3" }
    product_id = { S = "PROD-004" }
    score = { N = "5" }
    description = { S = "Qualidade JBL como sempre. Bateria dura muito e o som é cristalino." }
    created_at = { S = "2024-02-18T16:45:00Z" }
    user_name = { S = "André Souza" }
  })
}

resource "aws_dynamodb_table_item" "review_004_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-004-4" }
    product_id = { S = "PROD-004" }
    score = { N = "3" }
    description = { S = "Bom fone, mas o material plástico parece frágil." }
    created_at = { S = "2024-02-19T11:30:00Z" }
    user_name = { S = "Renata Lima" }
  })
}

resource "aws_dynamodb_table_item" "review_004_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-004-5" }
    product_id = { S = "PROD-004" }
    score = { N = "4" }
    description = { S = "Muito confortável e boa qualidade de som. Recomendo!" }
    created_at = { S = "2024-02-20T13:15:00Z" }
    user_name = { S = "Gabriel Ferreira" }
  })
}

# Reviews para PROD-005 (Dell Notebook)
resource "aws_dynamodb_table_item" "review_005_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-005-1" }
    product_id = { S = "PROD-005" }
    score = { N = "2" }
    description = { S = "Notebook com boa configuração, mas a performance deixa a desejar. Trava muito." }
    created_at = { S = "2024-02-21T10:00:00Z" }
    user_name = { S = "Roberto Alves" }
  })
}

resource "aws_dynamodb_table_item" "review_005_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-005-2" }
    product_id = { S = "PROD-005" }
    score = { N = "4" }
    description = { S = "Bom para trabalho básico. Tela boa e teclado confortável." }
    created_at = { S = "2024-02-22T15:30:00Z" }
    user_name = { S = "Marina Santos" }
  })
}

resource "aws_dynamodb_table_item" "review_005_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-005-3" }
    product_id = { S = "PROD-005" }
    score = { N = "3" }
    description = { S = "Performance ok para uso básico, mas esquenta muito durante uso intenso." }
    created_at = { S = "2024-02-23T12:45:00Z" }
    user_name = { S = "Lucas Oliveira" }
  })
}

resource "aws_dynamodb_table_item" "review_005_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-005-4" }
    product_id = { S = "PROD-005" }
    score = { N = "1" }
    description = { S = "Muito lento, não aguenta nem programas básicos. Não recomendo." }
    created_at = { S = "2024-02-24T17:20:00Z" }
    user_name = { S = "Patrícia Rocha" }
  })
}

resource "aws_dynamodb_table_item" "review_005_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-005-5" }
    product_id = { S = "PROD-005" }
    score = { N = "3" }
    description = { S = "Custo-benefício razoável. Serve para tarefas simples do dia a dia." }
    created_at = { S = "2024-02-25T09:10:00Z" }
    user_name = { S = "Thiago Costa" }
  })
}

# Reviews para PROD-006 (Echo Dot)
resource "aws_dynamodb_table_item" "review_006_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-006-1" }
    product_id = { S = "PROD-006" }
    score = { N = "5" }
    description = { S = "Echo Dot perfeito! Alexa responde muito bem e o som é surpreendente para o tamanho." }
    created_at = { S = "2024-02-26T08:30:00Z" }
    user_name = { S = "Camila Silva" }
  })
}

resource "aws_dynamodb_table_item" "review_006_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-006-2" }
    product_id = { S = "PROD-006" }
    score = { N = "4" }
    description = { S = "Muito útil para casa inteligente. Às vezes não entende comandos com ruído." }
    created_at = { S = "2024-02-27T14:15:00Z" }
    user_name = { S = "Eduardo Martins" }
  })
}

resource "aws_dynamodb_table_item" "review_006_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-006-3" }
    product_id = { S = "PROD-006" }
    score = { N = "3" }
    description = { S = "Bom produto, mas o som poderia ser mais alto para ambientes grandes." }
    created_at = { S = "2024-02-28T16:45:00Z" }
    user_name = { S = "Isabela Costa" }
  })
}

resource "aws_dynamodb_table_item" "review_006_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-006-4" }
    product_id = { S = "PROD-006" }
    score = { N = "5" }
    description = { S = "Excelente para automação residencial. Fácil configuração e muito responsivo." }
    created_at = { S = "2024-03-01T11:20:00Z" }
    user_name = { S = "Rafael Santos" }
  })
}

resource "aws_dynamodb_table_item" "review_006_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-006-5" }
    product_id = { S = "PROD-006" }
    score = { N = "4" }
    description = { S = "Ótimo custo-benefício. Design bonito e funcionalidades úteis." }
    created_at = { S = "2024-03-02T13:30:00Z" }
    user_name = { S = "Larissa Oliveira" }
  })
}

# Reviews para PROD-007 (Kindle)
resource "aws_dynamodb_table_item" "review_007_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-007-1" }
    product_id = { S = "PROD-007" }
    score = { N = "5" }
    description = { S = "Kindle perfeito! Tela antirreflexo excelente e bateria dura semanas." }
    created_at = { S = "2024-03-03T09:15:00Z" }
    user_name = { S = "Daniela Lima" }
  })
}

resource "aws_dynamodb_table_item" "review_007_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-007-2" }
    product_id = { S = "PROD-007" }
    score = { N = "4" }
    description = { S = "Muito bom para leitura. Só falta mais opções de fonte e formatação." }
    created_at = { S = "2024-03-04T15:40:00Z" }
    user_name = { S = "Gustavo Ferreira" }
  })
}

resource "aws_dynamodb_table_item" "review_007_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-007-3" }
    product_id = { S = "PROD-007" }
    score = { N = "5" }
    description = { S = "Resistente à água como prometido. Ótimo para ler na praia ou piscina." }
    created_at = { S = "2024-03-05T12:25:00Z" }
    user_name = { S = "Vanessa Rocha" }
  })
}

resource "aws_dynamodb_table_item" "review_007_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-007-4" }
    product_id = { S = "PROD-007" }
    score = { N = "3" }
    description = { S = "Bom leitor, mas a interface poderia ser mais intuitiva para navegação." }
    created_at = { S = "2024-03-06T18:10:00Z" }
    user_name = { S = "Bruno Silva" }
  })
}

resource "aws_dynamodb_table_item" "review_007_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-007-5" }
    product_id = { S = "PROD-007" }
    score = { N = "4" }
    description = { S = "Excelente para quem lê muito. Luz ajustável é perfeita para leitura noturna." }
    created_at = { S = "2024-03-07T20:35:00Z" }
    user_name = { S = "Amanda Costa" }
  })
}

# Reviews para PROD-008 (Apple Watch)
resource "aws_dynamodb_table_item" "review_008_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-008-1" }
    product_id = { S = "PROD-008" }
    score = { N = "5" }
    description = { S = "Apple Watch incrível! Monitoramento de saúde preciso e design elegante." }
    created_at = { S = "2024-03-08T10:20:00Z" }
    user_name = { S = "Felipe Santos" }
  })
}

resource "aws_dynamodb_table_item" "review_008_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-008-2" }
    product_id = { S = "PROD-008" }
    score = { N = "4" }
    description = { S = "Muito bom, mas a bateria poderia durar mais que um dia." }
    created_at = { S = "2024-03-09T14:50:00Z" }
    user_name = { S = "Priscila Lima" }
  })
}

resource "aws_dynamodb_table_item" "review_008_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-008-3" }
    product_id = { S = "PROD-008" }
    score = { N = "3" }
    description = { S = "Funciona bem, mas é caro para as funcionalidades oferecidas." }
    created_at = { S = "2024-03-10T16:15:00Z" }
    user_name = { S = "Rodrigo Oliveira" }
  })
}

resource "aws_dynamodb_table_item" "review_008_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-008-4" }
    product_id = { S = "PROD-008" }
    score = { N = "5" }
    description = { S = "Perfeito para exercícios! GPS preciso e resistente à água." }
    created_at = { S = "2024-03-11T08:45:00Z" }
    user_name = { S = "Tatiana Ferreira" }
  })
}

resource "aws_dynamodb_table_item" "review_008_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-008-5" }
    product_id = { S = "PROD-008" }
    score = { N = "4" }
    description = { S = "Ótimo smartwatch. Interface intuitiva e boa integração com iPhone." }
    created_at = { S = "2024-03-12T12:30:00Z" }
    user_name = { S = "Leonardo Costa" }
  })
}

# Reviews para PROD-009 (Xiaomi Redmi)
resource "aws_dynamodb_table_item" "review_009_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-009-1" }
    product_id = { S = "PROD-009" }
    score = { N = "4" }
    description = { S = "Excelente custo-benefício! Tela AMOLED linda e performance boa." }
    created_at = { S = "2024-03-13T11:10:00Z" }
    user_name = { S = "Juliana Santos" }
  })
}

resource "aws_dynamodb_table_item" "review_009_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-009-2" }
    product_id = { S = "PROD-009" }
    score = { N = "5" }
    description = { S = "Smartphone incrível pelo preço! Câmera boa e bateria dura bastante." }
    created_at = { S = "2024-03-14T15:25:00Z" }
    user_name = { S = "Marcelo Lima" }
  })
}

resource "aws_dynamodb_table_item" "review_009_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-009-3" }
    product_id = { S = "PROD-009" }
    score = { N = "3" }
    description = { S = "Bom celular, mas a interface MIUI é confusa e tem muitos apps pré-instalados." }
    created_at = { S = "2024-03-15T17:40:00Z" }
    user_name = { S = "Carolina Rocha" }
  })
}

resource "aws_dynamodb_table_item" "review_009_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-009-4" }
    product_id = { S = "PROD-009" }
    score = { N = "4" }
    description = { S = "Muito bom para o preço. Tela 120Hz é suave e responsiva." }
    created_at = { S = "2024-03-16T13:55:00Z" }
    user_name = { S = "Vinicius Silva" }
  })
}

resource "aws_dynamodb_table_item" "review_009_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-009-5" }
    product_id = { S = "PROD-009" }
    score = { N = "2" }
    description = { S = "Decepcionante. Esquenta muito durante jogos e a câmera não é tão boa quanto esperava." }
    created_at = { S = "2024-03-17T19:20:00Z" }
    user_name = { S = "Renato Costa" }
  })
}

# Reviews para PROD-010 (Nintendo Switch)
resource "aws_dynamodb_table_item" "review_010_1" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-010-1" }
    product_id = { S = "PROD-010" }
    score = { N = "5" }
    description = { S = "Nintendo Switch OLED perfeito! Tela linda e versatilidade incrível." }
    created_at = { S = "2024-03-18T10:30:00Z" }
    user_name = { S = "Mateus Santos" }
  })
}

resource "aws_dynamodb_table_item" "review_010_2" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-010-2" }
    product_id = { S = "PROD-010" }
    score = { N = "4" }
    description = { S = "Excelente console! Só falta mais armazenamento interno." }
    created_at = { S = "2024-03-19T14:45:00Z" }
    user_name = { S = "Bianca Lima" }
  })
}

resource "aws_dynamodb_table_item" "review_010_3" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-010-3" }
    product_id = { S = "PROD-010" }
    score = { N = "3" }
    description = { S = "Bom console, mas os Joy-Con apresentam drift após alguns meses de uso." }
    created_at = { S = "2024-03-20T16:20:00Z" }
    user_name = { S = "Alexandre Oliveira" }
  })
}

resource "aws_dynamodb_table_item" "review_010_4" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-010-4" }
    product_id = { S = "PROD-010" }
    score = { N = "5" }
    description = { S = "Incrível para toda família! Jogos divertidos e portabilidade perfeita." }
    created_at = { S = "2024-03-21T12:15:00Z" }
    user_name = { S = "Fernanda Costa" }
  })
}

resource "aws_dynamodb_table_item" "review_010_5" {
  table_name = aws_dynamodb_table.reviews.name
  hash_key   = aws_dynamodb_table.reviews.hash_key
  item = jsonencode({
    review_id = { S = "REV-010-5" }
    product_id = { S = "PROD-010" }
    score = { N = "4" }
    description = { S = "Console fantástico! Tela OLED faz toda diferença na qualidade visual." }
    created_at = { S = "2024-03-22T18:50:00Z" }
    user_name = { S = "Diego Ferreira" }
  })
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.products.arn,
          aws_dynamodb_table.reviews.arn,
          aws_dynamodb_table.insights.arn,
          "${aws_dynamodb_table.products.arn}/index/*",
          "${aws_dynamodb_table.reviews.arn}/index/*",
          "${aws_dynamodb_table.insights.arn}/index/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = "*"
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "review_api" {
  filename         = "lambda/api-handler.zip"
  function_name    = "${var.project_name}-review-api"
  role            = aws_iam_role.lambda_role.arn
  handler         = "api-handler.lambda_handler"
  runtime         = "python3.11"
  timeout         = 60

  environment {
    variables = {
      PRODUCTS_TABLE = aws_dynamodb_table.products.name
      reviews  = aws_dynamodb_table.reviews.name
      INSIGHTS_TABLE = aws_dynamodb_table.insights.name
    }
  }

  tags = var.tags
}

# API Gateway
resource "aws_api_gateway_rest_api" "review_api" {
  name        = "${var.project_name}-review-api"
  description = "Review Analysis API"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

# CORS for API Gateway
resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.review_api.id
  resource_id   = aws_api_gateway_rest_api.review_api.root_resource_id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  resource_id = aws_api_gateway_rest_api.review_api.root_resource_id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"
  
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  resource_id = aws_api_gateway_rest_api.review_api.root_resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  resource_id = aws_api_gateway_rest_api.review_api.root_resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options.status_code
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# /reviews resource
resource "aws_api_gateway_resource" "reviews" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  parent_id   = aws_api_gateway_rest_api.review_api.root_resource_id
  path_part   = "reviews"
}

# POST /reviews
resource "aws_api_gateway_method" "reviews_post" {
  rest_api_id   = aws_api_gateway_rest_api.review_api.id
  resource_id   = aws_api_gateway_resource.reviews.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "reviews_post" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  resource_id = aws_api_gateway_resource.reviews.id
  http_method = aws_api_gateway_method.reviews_post.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.review_api.invoke_arn
}

# /admin resource
resource "aws_api_gateway_resource" "admin" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  parent_id   = aws_api_gateway_rest_api.review_api.root_resource_id
  path_part   = "admin"
}

# /admin/reviews resource
resource "aws_api_gateway_resource" "admin_reviews" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  parent_id   = aws_api_gateway_resource.admin.id
  path_part   = "reviews"
}

# GET /admin/reviews
resource "aws_api_gateway_method" "admin_reviews_get" {
  rest_api_id   = aws_api_gateway_rest_api.review_api.id
  resource_id   = aws_api_gateway_resource.admin_reviews.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "admin_reviews_get" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  resource_id = aws_api_gateway_resource.admin_reviews.id
  http_method = aws_api_gateway_method.admin_reviews_get.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.review_api.invoke_arn
}

# /store resource
resource "aws_api_gateway_resource" "store" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  parent_id   = aws_api_gateway_rest_api.review_api.root_resource_id
  path_part   = "store"
}

# /store/reviews resource
resource "aws_api_gateway_resource" "store_reviews" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  parent_id   = aws_api_gateway_resource.store.id
  path_part   = "reviews"
}

# GET /store/reviews
resource "aws_api_gateway_method" "store_reviews_get" {
  rest_api_id   = aws_api_gateway_rest_api.review_api.id
  resource_id   = aws_api_gateway_resource.store_reviews.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "store_reviews_get" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  resource_id = aws_api_gateway_resource.store_reviews.id
  http_method = aws_api_gateway_method.store_reviews_get.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.review_api.invoke_arn
}

# /products resource
resource "aws_api_gateway_resource" "products" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  parent_id   = aws_api_gateway_rest_api.review_api.root_resource_id
  path_part   = "products"
}

# GET /products
resource "aws_api_gateway_method" "products_get" {
  rest_api_id   = aws_api_gateway_rest_api.review_api.id
  resource_id   = aws_api_gateway_resource.products.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "products_get" {
  rest_api_id = aws_api_gateway_rest_api.review_api.id
  resource_id = aws_api_gateway_resource.products.id
  http_method = aws_api_gateway_method.products_get.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.review_api.invoke_arn
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "review_api" {
  depends_on = [
    aws_api_gateway_integration.reviews_post,
    aws_api_gateway_integration.admin_reviews_get,
    aws_api_gateway_integration.store_reviews_get,
    aws_api_gateway_integration.products_get
  ]

  rest_api_id = aws_api_gateway_rest_api.review_api.id
}

resource "aws_api_gateway_stage" "review_api_prod" {
  deployment_id = aws_api_gateway_deployment.review_api.id
  rest_api_id   = aws_api_gateway_rest_api.review_api.id
  stage_name    = "prod"
}

# Lambda Permissions
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.review_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.review_api.execution_arn}/*/*"
}
