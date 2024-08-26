module "network" {
  source  = "../../modules/vpc"
  egress  = false
  ingress = true
  region  = var.aws_region
  vpc     = var.vpc

}

module "ses" {
  source  = "../../modules/ses"
  domain  = var.domain
  inbound = true
}


resource "aws_ses_receipt_rule_set" "this" {
  rule_set_name = "remarkable-rules"
}

resource "aws_ses_active_receipt_rule_set" "this" {
  rule_set_name = "remarkable-rules"
}

resource "aws_ses_receipt_rule" "store" {
  name          = "store"
  rule_set_name = aws_ses_receipt_rule_set.this.rule_set_name
  recipients    = ["remarkable@${var.domain}"]
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name       = module.s3.bucket
    object_key_prefix = "/in"
    kms_key_arn       = module.s3.bucket_key
    position          = 1
  }

  lambda_action {
    function_arn    = module.lambda.function_arn
    invocation_type = "Event"
    position        = 2
  }
}

module "s3" {
  source             = "../../modules/s3"
  project            = "potteringabout"
  environment        = var.environment
  bucket_name        = "remarkable"
  bucket_policy_json = data.aws_iam_policy_document.s3_policy.json
  kms_policy_json    = data.aws_iam_policy_document.kms_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${module.s3.bucket_arn}/*"
    ]

    /*condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }*/

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:receipt-rule-set/remarkable-rules:receipt-rule/store"
      ]
    }
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${module.s3.bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "kms_policy" {

  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  #checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*"
    ]

  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }

    actions = [
      "kms:GenerateDataKey*",
    ]

    resources = [
      "*"
    ]

    /*condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }*/

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:receipt-rule-set/remarkable-rules:receipt-rule/store"
      ]
    }
  }
}


module "lambda" {
  source                  = "../../modules/lambda"
  function_name           = "email-extract"
  function_dir            = "../../lambda/extract-mail"
  function_runtime        = "python3.12"
  function_handler        = "extract-mail.lambda_handler"
  function_role           = "email-extract"
  function_policy_json    = data.aws_iam_policy_document.lambda_policy.json
  function_exec_service   = "ses.amazonaws.com"
  function_exec_arn       = "arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:receipt-rule-set/remarkable-rules:receipt-rule/store"
  function_exec_allowname = "AllowFromSES"


}

data "aws_iam_policy_document" "lambda_policy" {
  #checkov:skip=CKV_AWS_108: "Ensure IAM policies does not allow data exfiltration"
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  #checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  statement {

    actions = [
      "s3:*",
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]

    resources = [
      "*"
    ]

  }
}

module "lambda2" {
  source                  = "../../modules/lambda"
  function_name           = "textract"
  function_dir            = "../../lambda/textract"
  function_runtime        = "python3.12"
  function_handler        = "textract.lambda_handler"
  function_role           = "textract"
  function_policy_json    = data.aws_iam_policy_document.lambda2_policy.json
  function_exec_service   = "s3.amazonaws.com"
  function_exec_arn       = "arn:aws:s3:::${module.s3.bucket}"
  function_exec_allowname = "AllowFromS3"

  s3_object_trigger = {
    bucket        = module.s3.bucket_id
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "/out/"
    filter_suffix = null
  }
}

data "aws_iam_policy_document" "lambda2_policy" {
  #checkov:skip=CKV_AWS_108: "Ensure IAM policies does not allow data exfiltration"
  #checkov:skip=CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  #checkov:skip=CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  statement {

    actions = [
      "s3:*",
      "kms:GenerateDataKey*",
      "kms:Decrypt",
      "textract:*"
    ]

    resources = [
      "*"
    ]

  }


}
