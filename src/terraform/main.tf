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