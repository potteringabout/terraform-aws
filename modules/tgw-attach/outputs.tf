output "transit_gateway_vpc_attachment_id" {
  description = "The ID of the Transit Gateway attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.id
}

output "transit_gateway_vpc_attachment_vpc_id" {
  description = "The ARN of the created Transit Gateway"
  value       = aws_ec2_transit_gateway_vpc_attachment.this.vpc_id
}
