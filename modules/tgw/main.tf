resource "aws_ec2_transit_gateway" "this" {
  description                     = var.description
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support

  tags = {
    Name = var.tgw_name
  }
}

# Create the Inbound Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "inbound" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.tgw_name}-inbound"
  }
}

# Create the Outbound Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "outbound" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.tgw_name}-outbound"
  }
}
