# Cloud provider and region
provider "aws" {
    region = "${var.aws_region}"
}

provider "compress" {}

# Lambda handler
data "compress_lambda" "zip" {
    type = "zip"
    source_file = "lambdas/handler1.py"
    output_path = "lambda.zip"
}

# IAM policy
data "aws_iam_policy_document" "policy" {
    statement {
        sid = ""
        effect = "Allow"
        
        principals = {
            identifiers = ["lambda.amazonaws.com"]
            type = "service"
        }
        actions = ["sts:AssumeRole"]
    }
}

# Resources
resource "aws_iam_role" "lambda_iam" {
    name = "lambda_iam"
    assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_lambda_function" "lambda" {
    function_name = "handler1"
    filename = "${data.compress_lambda.zip.output_path}"
    source_code_hash = "${data.compress_lambda.zip.output_base64sha256}"
    role = "${aws_iam_role.lambda_iam.arn}"
    handler = "handler1.handler"
    runtime = "python3.6"
}