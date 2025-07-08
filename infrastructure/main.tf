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

  global_secondary_index {
    name            = "category-index"
    hash_key        = "category"
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

resource "aws_dynamodb_table" "contents" {
  name           = "${var.project_name}-contents"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "content_id"

  attribute {
    name = "content_id"
    type = "S"
  }

  attribute {
    name = "product_id"
    type = "S"
  }

  attribute {
    name = "type"
    type = "S"
  }

  attribute {
    name = "text"
    type = "S"
  }

  attribute {
    name = "image_url"
    type = "S"
  }

  attribute {
    name = "status"
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

  global_secondary_index {
    name            = "product-index"
    hash_key        = "product_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "type-index"
    hash_key        = "type"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "text-index"
    hash_key        = "text"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "image-url-index"
    hash_key        = "image_url"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "status-index"
    hash_key        = "status"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "contents-created-at-index"
    hash_key        = "created_at"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "contents-updated-at-index"
    hash_key        = "updated_at"
    projection_type = "ALL"
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "approvals" {
  name           = "${var.project_name}-approvals"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "approval_id"

  attribute {
    name = "approval_id"
    type = "S"
  }

  attribute {
    name = "content_id"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "comment"
    type = "S"
  }

  attribute {
    name = "approver_id"
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

  global_secondary_index {
    name            = "content-index"
    hash_key        = "content_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "status-index"
    hash_key        = "status"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "comment-index"
    hash_key        = "comment"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "approver-id-index"
    hash_key        = "approver_id"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "approvals-created-at-index"
    hash_key        = "created_at"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "approvals-updated-at-index"
    hash_key        = "updated_at"
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
  })
}

# S3 Bucket
resource "aws_s3_bucket" "content_assets" {
  bucket = "${var.project_name}-content-assets-${random_string.bucket_suffix.result}"
  tags   = var.tags
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket_public_access_block" "content_assets" {
  bucket = aws_s3_bucket.content_assets.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "content_assets" {
  bucket = aws_s3_bucket.content_assets.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.content_assets.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.content_assets]
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "content_cdn" {
  origin {
    domain_name = aws_s3_bucket.content_assets.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.content_assets.id}"
  }

  enabled = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.content_assets.id}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = var.tags
}

# SNS Topic
resource "aws_sns_topic" "approval_notifications" {
  name = "${var.project_name}-approval-notifications"
  tags = var.tags
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
          aws_dynamodb_table.contents.arn,
          aws_dynamodb_table.approvals.arn,
          "${aws_dynamodb_table.products.arn}/index/*",
          "${aws_dynamodb_table.contents.arn}/index/*",
          "${aws_dynamodb_table.approvals.arn}/index/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.content_assets.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.approval_notifications.arn
      }
    ]
  })
}

# Lambda Functions
resource "aws_lambda_function" "content_generation" {
  filename         = "lambda/content-generation.zip"
  function_name    = "${var.project_name}-content-generation"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.11"
  timeout         = 300

  environment {
    variables = {
      products = aws_dynamodb_table.products.name
      CONTENTS_TABLE = aws_dynamodb_table.contents.name
      S3_BUCKET      = aws_s3_bucket.content_assets.bucket
    }
  }

  tags = var.tags
}

resource "aws_lambda_function" "approval_handler" {
  filename         = "lambda/approval-handler.zip"
  function_name    = "${var.project_name}-approval-handler"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.11"
  timeout         = 60

  environment {
    variables = {
      CONTENTS_TABLE   = aws_dynamodb_table.contents.name
      APPROVALS_TABLE  = aws_dynamodb_table.approvals.name
      SNS_TOPIC_ARN    = aws_sns_topic.approval_notifications.arn
    }
  }

  tags = var.tags
}

resource "aws_lambda_function" "public_api" {
  filename         = "lambda/public-api.zip"
  function_name    = "${var.project_name}-public-api"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "python3.11"
  timeout         = 30

  environment {
    variables = {
      products   = aws_dynamodb_table.products.name
      CONTENTS_TABLE   = aws_dynamodb_table.contents.name
      APPROVALS_TABLE  = aws_dynamodb_table.approvals.name
      CDN_DOMAIN       = aws_cloudfront_distribution.content_cdn.domain_name
    }
  }

  tags = var.tags
}

# API Gateway - Admin
resource "aws_api_gateway_rest_api" "admin_api" {
  name        = "${var.project_name}-admin-api"
  description = "Admin API for content management"
  tags        = var.tags
}

resource "aws_api_gateway_resource" "admin_generate" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  parent_id   = aws_api_gateway_rest_api.admin_api.root_resource_id
  path_part   = "generate"
}

resource "aws_api_gateway_method" "admin_generate_post" {
  rest_api_id   = aws_api_gateway_rest_api.admin_api.id
  resource_id   = aws_api_gateway_resource.admin_generate.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "admin_generate_integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_generate.id
  http_method = aws_api_gateway_method.admin_generate_post.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.content_generation.invoke_arn
}

resource "aws_api_gateway_resource" "admin_approve" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  parent_id   = aws_api_gateway_rest_api.admin_api.root_resource_id
  path_part   = "approve"
}

resource "aws_api_gateway_resource" "admin_approve_id" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  parent_id   = aws_api_gateway_resource.admin_approve.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "admin_approve_put" {
  rest_api_id   = aws_api_gateway_rest_api.admin_api.id
  resource_id   = aws_api_gateway_resource.admin_approve_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "admin_approve_integration" {
  rest_api_id = aws_api_gateway_rest_api.admin_api.id
  resource_id = aws_api_gateway_resource.admin_approve_id.id
  http_method = aws_api_gateway_method.admin_approve_put.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.approval_handler.invoke_arn
}

# API Gateway - Public
resource "aws_api_gateway_rest_api" "public_api" {
  name        = "${var.project_name}-public-api"
  description = "Public API for e-commerce"
  tags        = var.tags
}

resource "aws_api_gateway_resource" "public_products" {
  rest_api_id = aws_api_gateway_rest_api.public_api.id
  parent_id   = aws_api_gateway_rest_api.public_api.root_resource_id
  path_part   = "products"
}

resource "aws_api_gateway_method" "public_products_get" {
  rest_api_id   = aws_api_gateway_rest_api.public_api.id
  resource_id   = aws_api_gateway_resource.public_products.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "public_products_integration" {
  rest_api_id = aws_api_gateway_rest_api.public_api.id
  resource_id = aws_api_gateway_resource.public_products.id
  http_method = aws_api_gateway_method.public_products_get.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.public_api.invoke_arn
}

# API Gateway Deployments
resource "aws_api_gateway_deployment" "admin_api" {
  depends_on = [
    aws_api_gateway_integration.admin_generate_integration,
    aws_api_gateway_integration.admin_approve_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.admin_api.id
}

resource "aws_api_gateway_stage" "admin_api_prod" {
  deployment_id = aws_api_gateway_deployment.admin_api.id
  rest_api_id   = aws_api_gateway_rest_api.admin_api.id
  stage_name    = "prod"
}

resource "aws_api_gateway_deployment" "public_api" {
  depends_on = [
    aws_api_gateway_integration.public_products_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.public_api.id
}

resource "aws_api_gateway_stage" "public_api_prod" {
  deployment_id = aws_api_gateway_deployment.public_api.id
  rest_api_id   = aws_api_gateway_rest_api.public_api.id
  stage_name    = "prod"
}

# Lambda Permissions
resource "aws_lambda_permission" "admin_api_content_generation" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.content_generation.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.admin_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "admin_api_approval_handler" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.approval_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.admin_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "public_api_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.public_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.public_api.execution_arn}/*/*"
}