# Lambda ARN
output "lambda_arn" {
  value = aws_lambda_function.cifras_lambda.arn
}

# Lambda name
output "lambda_name" {
  value = aws_lambda_function.cifras_lambda.function_name
}

# DynamoDB table name
output "dynamodb_table_name" {
  value = aws_dynamodb_table.calculation_results.name
}

# DynamoDB table ARN
output "dynamodb_table_arn" {
  value = aws_dynamodb_table.calculation_results.arn
}

# API Gateway endpoint
output "api_url" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}