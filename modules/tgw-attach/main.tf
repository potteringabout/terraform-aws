locals {
  static_routes = [
    for k, prop in var.tgw_route_table_ids_propagation : {
      for k, route in var.tgw_static_routes :
      "${prop}-${route}" => {
        "route"       = route
        "propagation" = prop
      }
    }
  ]
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
  transit_gateway_route_table_id = var.tgw_route_table_id_association
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each                       = var.tgw_route_table_ids_propagation
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = each.value
}


resource "aws_ec2_transit_gateway_route" "static_route" {
  for_each                       = local.static_routes
  destination_cidr_block         = each.value["route"]
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = each.value["propagation"]

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
