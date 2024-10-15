output "transit_gateway_id" {
  description = "The ID of the created Transit Gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "transit_gateway_arn" {
  description = "The ARN of the created Transit Gateway"
  value       = aws_ec2_transit_gateway.this.arn
}

output "inbound_route_table_id" {
  description = "The ID of the inbound route table"
  value       = aws_ec2_transit_gateway_route_table.inbound.id
}

output "outbound_route_table_id" {
  description = "The ID of the outbound route table"
  value       = aws_ec2_transit_gateway_route_table.outbound.id
}
