output "api_gateway_url" {
  description = "API Gateway URL"
  value       = "https://${aws_api_gateway_rest_api.review_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.review_api_prod.stage_name}"
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.review_api.function_name
}

output "dynamodb_tables" {
  description = "DynamoDB table names"
  value = {
    products = aws_dynamodb_table.products.name
    reviews  = aws_dynamodb_table.reviews.name
    insights = aws_dynamodb_table.insights.name
  }
}

output "api_endpoints" {
  description = "API endpoints"
  value = {
    create_review    = "POST ${aws_api_gateway_rest_api.review_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.review_api_prod.stage_name}/reviews"
    admin_reviews    = "GET ${aws_api_gateway_rest_api.review_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.review_api_prod.stage_name}/admin/reviews"
    store_reviews    = "GET ${aws_api_gateway_rest_api.review_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.review_api_prod.stage_name}/store/reviews"
    list_products    = "GET ${aws_api_gateway_rest_api.review_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.review_api_prod.stage_name}/products"
  }
}