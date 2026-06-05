provider "aws" {
  region = var.aws_region
}

# Existing IAM role
data "aws_iam_role" "lab_role" {
  name = var.lab_role_name
}

# DynamoDB table
resource "aws_dynamodb_table" "calculation_results" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# CloudWatch log group
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 7
}

# Lambda function
resource "aws_lambda_function" "cifras_lambda" {

  function_name = var.lambda_name

  role = data.aws_iam_role.lab_role.arn

  runtime = "java21"

  handler = "com.kangoo.cyl.lambda.SolverLambdaHandler::handleRequest"

  filename         = "${path.module}/artifacts/lambda.jar"
  source_code_hash = filebase64sha256("${path.module}/artifacts/lambda.jar")

  memory_size = 512
  timeout     = 30

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.calculation_results.name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_logs
  ]
}

# API Gateway
resource "aws_apigatewayv2_api" "http_api" {
  name          = "cifras-api"
  protocol_type = "HTTP"
}

# Integración API Gateway con Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {

  api_id = aws_apigatewayv2_api.http_api.id

  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.cifras_lambda.invoke_arn

  payload_format_version = "2.0"
}

# POST
resource "aws_apigatewayv2_route" "solve_route" {

  api_id = aws_apigatewayv2_api.http_api.id

  route_key = "POST /solve"

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Stage (deploy automático)
resource "aws_apigatewayv2_stage" "default_stage" {

  api_id = aws_apigatewayv2_api.http_api.id

  name = "$default"

  auto_deploy = true
}

# Permiso para que API Gateway invoque Lambda
resource "aws_lambda_permission" "apigw_invoke" {

  statement_id  = "AllowAPIGatewayInvoke"

  action        = "lambda:InvokeFunction"

  function_name = aws_lambda_function.cifras_lambda.function_name

  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}