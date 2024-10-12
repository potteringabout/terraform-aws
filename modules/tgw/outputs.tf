output "transit_gateway_id" {
  description = "The ID of the created Transit Gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_arn" {
  description = "The ARN of the created Transit Gateway"
  value       = aws_ec2_transit_gateway.this.arn
}
