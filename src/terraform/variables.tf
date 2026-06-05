variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "lambda_name" {
  description = "Lambda function name"
  type        = string
  default     = "cifras-lambda"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "CalculationResults"
}

variable "lab_role_name" {
  description = "Existing Learner Lab IAM role"
  type        = string
  default     = "LabRole"
}