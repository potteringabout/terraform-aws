output "bucket" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_key" {
  value = aws_kms_key.this.arn
}

/*
output "bucket" {
  value = value = "${var.project}-${var.environment}-${var.bucket_name}"
}

output "bucket_arn" {
  value = "arn:aws:s3:::${var.project}-${var.environment}-${var.bucket_name}"
}

output "bucket_id" {
  value = "arn:aws:s3:::${var.project}-${var.environment}-${var.bucket_name}"
}

output "bucket_key" {
  value = aws_kms_key.this.arn
}
*/
