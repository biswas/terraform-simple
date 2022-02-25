# Cloud provider and region
provider "aws" {
  region = var.aws_region
}

provider "archive" {}

# Lambda handler
data "archive_file" "zip" {
  type        = "zip"
  source_file = "./lambdas/handler1.py"
  output_path = "lambda.zip"
}

# IAM policy
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "service"
    }
    actions = ["sts:AssumeRole"]
  }
}

# Resources
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "lambda" {
  function_name    = "handler1"
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "handler1.handler"
  runtime          = "python3.6"
}