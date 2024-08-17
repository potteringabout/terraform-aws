resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "_amazonses.${aws_ses_domain_identity.this.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.this.verification_token]
}

resource "aws_ses_domain_identity_verification" "this" {
  domain = aws_ses_domain_identity.this.id

  depends_on = [aws_route53_record.this]
}

resource "aws_ses_receipt_rule_set" "this" {
  rule_set_name = "remarkable-rules"
}

resource "aws_ses_receipt_rule" "store" {
  name          = "store"
  rule_set_name = aws_ses_receipt_rule_set.this.rule_set_name
  recipients    = ["remarkable@${var.domain}"]
  enabled       = true
  scan_enabled  = true

  add_header_action {
    header_name  = "Custom-Header"
    header_value = "Added by SES for Remarkable"
    position     = 1
  }

  s3_action {
    bucket_name       = var.bucket
    object_key_prefix = "/remarkable/in"
    kms_key_arn       = var.bucket_key
    position          = 2
  }
}
