output "bucket" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_key" {
  value = aws_kms_key.this.arn
}
