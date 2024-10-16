data "aws_ec2_transit_gateway_route_table" "association" {
  filter {
    name   = "tag:Name"
    values = [var.tgw_route_table_id_association]
  }
}

data "aws_ec2_transit_gateway_route_table" "propagation" {
  count = var.tgw_route_table_id_propagation != null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.tgw_route_table_id_propagation]
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.tgw_id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  tags = {
    Name = var.tgw_attachment_name
  }
}

# Optional: Associate and propagate the Outbound Route Table to the TGW
resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.association.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  count = var.tgw_route_table_id_propagation != null ? 1 : 0
  #for_each                       = var.tgw_route_table_ids_propagation
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.propagation[0].id
}

resource "aws_ec2_transit_gateway_route" "static_route" {
  for_each                       = var.tgw_static_routes
  destination_cidr_block         = each.value
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.propagation[0].id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
