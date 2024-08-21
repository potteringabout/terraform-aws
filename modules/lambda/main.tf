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
  name               = var.function_role
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



resource "aws_iam_role_policy" "this" {
  name   = "test_policy"
  role   = aws_iam_role.this.id
  policy = var.function_policy_json
}


data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = var.function_dir
  output_path = "/tmp/lambda_function.zip"
}

resource "aws_lambda_function" "this" {
  #checkov:skip=CKV_AWS_173: "Check encryption settings for Lambda environmental variable"
  #checkov:skip=CKV_AWS_50: "X-Ray tracing is enabled for Lambda"
  #checkov:skip=CKV_AWS_117: "Ensure that AWS Lambda function is configured inside a VPC"
  #checkov:skip=CKV_AWS_115: "Ensure that AWS Lambda function is configured for function-level concurrent execution limit"
  #checkov:skip=CKV_AWS_116: "Ensure that AWS Lambda function is configured for a Dead Letter Queue(DLQ)"
  #checkov:skip=CKV_AWS_272: "Ensure AWS Lambda function is configured to validate code-signing"

  filename      = "/tmp/lambda_function.zip"
  function_name = var.function_name
  role          = aws_iam_role.this.arn
  handler       = var.function_handler

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = var.function_runtime
  timeout = var.funtion_timeout

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_permission" "this" {
  statement_id  = var.function_exec_allowname
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = var.function_exec_service
  source_arn    = var.function_exec_arn
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  count  = var.s3_object_trigger["bucket"] != null ? 1 : 0
  bucket = var.s3_object_trigger["bucket"]
  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = var.s3_object_trigger["events"]
    filter_prefix       = var.s3_object_trigger["filter_prefix"]
    filter_suffix       = var.s3_object_trigger["filter_suffix"]
  }
}
