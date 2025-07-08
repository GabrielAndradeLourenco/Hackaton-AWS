#!/bin/bash

echo "🚀 Starting deployment..."

# Create lambda directory if it doesn't exist
mkdir -p infrastructure/lambda

# Package Lambda function
echo "📦 Packaging Lambda function..."
cd infrastructure/lambda
cp ../../api-handler.py .
zip -r api-handler.zip api-handler.py
cd ..

# Initialize and apply Terraform
echo "🏗️ Deploying infrastructure..."
terraform init
terraform plan
terraform apply -auto-approve

# Get API Gateway URL
API_URL=$(terraform output -raw api_gateway_url)
echo ""
echo "✅ Deployment complete!"
echo "🌐 API Gateway URL: $API_URL"
echo ""
echo "📋 Available endpoints:"
echo "  GET  $API_URL/products"
echo "  POST $API_URL/reviews"
echo "  GET  $API_URL/admin/reviews?product_id=PROD-001"
echo "  GET  $API_URL/store/reviews?product_id=PROD-001"
echo ""
echo "🧪 Test with:"
echo "# List products"
echo "curl $API_URL/products"
echo ""
echo "# Create review"
echo "curl -X POST $API_URL/reviews \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -d '{\"user_name\":\"Test User\",\"score\":5,\"description\":\"Great product!\",\"product_id\":\"PROD-001\"}'"