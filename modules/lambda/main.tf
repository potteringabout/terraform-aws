data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "this" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy" "this" {
  name   = "test_policy"
  role   = aws_iam_role.this.id
  policy = var.function_policy_json
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = var.function_file
  output_path = "${path.temp}/lambda_function.zip"
}

resource "aws_lambda_function" "this" {
  #checkov:skip=CKV_AWS_173: "Check encryption settings for Lambda environmental variable"
  #checkov:skip=CKV_AWS_50: "X-Ray tracing is enabled for Lambda"
  #checkov:skip=CKV_AWS_117: "Ensure that AWS Lambda function is configured inside a VPC"
  #checkov:skip=CKV_AWS_115: "Ensure that AWS Lambda function is configured for function-level concurrent execution limit"
  #checkov:skip=CKV_AWS_116: "Ensure that AWS Lambda function is configured for a Dead Letter Queue(DLQ)"
  #checkov:skip=CKV_AWS_272: "Ensure AWS Lambda function is configured to validate code-signing"

  filename      = "${path.temp}/lambda_function.zip"
  function_name = var.function_name
  role          = aws_iam_role.this.arn
  handler       = var.function_handler

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = var.function_runtime

  environment {
    variables = {
      foo = "bar"
    }
  }
}
