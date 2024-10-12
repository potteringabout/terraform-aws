module "vpcs" {
  source   = "../../modules/vpc"
  for_each = var.vpcs

  region = var.aws_region
  vpc    = each.value
}


module "tgw" {
  source   = "../../modules/tgw"
  tgw_name = "tgw"
  #region = var.aws_region

}

data "aws_vpc" "inspection" {
  filter {
    name   = "tag:Name"
    values = ["*inspection*"]
  }
  depends_on = [module.vpcs]
}

data "aws_subnets" "inspection" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.inspection.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*tgw*"]
  }
}



resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = module.tgw.transit_gateway_id
  vpc_id             = data.aws_vpc.inspection.id
  subnet_ids         = data.aws_subnets.inspection.ids

  tags = {
    Name = "inspection"
  }
}
