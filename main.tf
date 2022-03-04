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

# IAM policy document for lambda
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM policy document for cloudwatch logging
data "aws_iam_policy_document" "policy_logging" {
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

# Resources
resource "aws_iam_role" "lambda_iam3" {
  name               = "lambda_iam3"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.lambda_function_name
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role             = aws_iam_role.lambda_iam3.arn
  handler          = "handler1.handler"
  runtime          = "python3.6"
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lgroup1
  ]
}

resource "aws_cloudwatch_log_group" "lgroup1" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 2
}

resource "aws_iam_policy" "lambda_logging" {
  name               = "lambda_logging"
  path               = "/"
  description        = "IAM policy for logging from a lambda"
  assume_role_policy = data.aws_iam_policy_document.policy_logging.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_iam3.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}