output "admin_api_url" {
  description = "Admin API Gateway URL"
  value       = "${aws_api_gateway_rest_api.admin_api.execution_arn}/prod"
}

output "public_api_url" {
  description = "Public API Gateway URL"
  value       = "${aws_api_gateway_rest_api.public_api.execution_arn}/prod"
}

output "s3_bucket_name" {
  description = "S3 bucket name for content assets"
  value       = aws_s3_bucket.content_assets.bucket
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain"
  value       = aws_cloudfront_distribution.content_cdn.domain_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN for notifications"
  value       = aws_sns_topic.approval_notifications.arn
}

output "dynamodb_tables" {
  description = "DynamoDB table names"
  value = {
    products  = aws_dynamodb_table.products.name
    contents  = aws_dynamodb_table.contents.name
    approvals = aws_dynamodb_table.approvals.name
  }
}

output "lambda_functions" {
  description = "Lambda function names"
  value = {
    content_generation = aws_lambda_function.content_generation.function_name
    approval_handler   = aws_lambda_function.approval_handler.function_name
    public_api         = aws_lambda_function.public_api.function_name
  }
}