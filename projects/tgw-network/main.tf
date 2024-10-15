locals {
  vpcs = {
    app = {
      cidr    = "10.0.0.0/16"
      name    = "app"
      ingress = true
      egress  = false
      subnets = {
        access = [
          {
            cidr = "10.0.0.0/25"
          },
          {
            cidr = "10.0.0.128/25"
          }
        ]
        data = [
          {
            cidr = "10.0.1.0/25"
          },
          {
            cidr = "10.0.1.128/25"
          }
        ]
        app = [
          {
            cidr = "10.0.2.0/25"
          },
          {
            cidr = "10.0.2.128/25"
          }
        ]
        tgw = [
          {
            cidr = "10.0.3.0/25"
          },
          {
            cidr = "10.0.3.128/25"
          }
        ]
        fw = [
          {
            cidr = "10.0.4.0/25"
          },
          {
            cidr = "10.0.4.128/25"
          }
        ]

      }
    },
    inspection = {
      cidr    = "10.1.0.0/16"
      name    = "inspection"
      ingress = false
      egress  = false
      subnets = {
        inspection = [
          {
            cidr = "10.1.0.0/25"
          },
          {
            cidr = "10.1.0.128/25"
          }
        ]
        tgw = [
          {
            cidr = "10.1.1.0/25"
          },
          {
            cidr = "10.1.1.128/25"
          }
        ]
      }
    },
    egress = {
      cidr    = "10.2.0.0/16"
      name    = "egress"
      ingress = false
      egress  = true
      subnets = {
        egress = [
          {
            cidr = "10.2.0.0/25"
          },
          {
            cidr = "10.2.0.128/25"
          }
        ]
        tgw = [
          {
            cidr = "10.2.1.0/25"
          },
          {
            cidr = "10.2.1.128/25"
          }
        ]
      }
    }
  }
  route_tables = ["inbound", "inspection"]
  vpc_attachments = {
    for k, vpc in module.vpcs : vpc.vpc_name => {
      vpc_id          = vpc.vpc_id
      name            = vpc.vpc_name
      tgw_route_table = vpc.vpc_name == "inspection" ? module.tgw.route_tables["inspection"].id : module.tgw.route_tables["inbound"].id
      #tgw_route_table_propagation = vpc.vpc_name == "inspection" ? null : module.tgw.route_tables["inspection"].id
      subnets = [
        for subnet in vpc.subnets :
        subnet["id"] if subnet["zone"] == "tgw"
      ]
    }
  }
}

module "vpcs" {
  source   = "../../modules/vpc"
  for_each = local.vpcs

  region = var.aws_region
  vpc    = each.value
}


module "tgw" {
  source       = "../../modules/tgw"
  tgw_name     = "tgw"
  route_tables = local.route_tables
}

/*
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
}*/

module "tgw_attach" {
  for_each = toset([for k, v in local.vpcs : k])

  source                         = "../../modules/tgw-attach"
  tgw_id                         = module.tgw.transit_gateway_id
  tgw_attachment_name            = local.vpc_attachments[each.value]["name"]
  vpc_id                         = local.vpc_attachments[each.value]["vpc_id"]
  subnet_ids                     = local.vpc_attachments[each.value]["subnets"]
  tgw_route_table_id_association = local.vpc_attachments[each.value]["tgw_route_table"]
  #tgw_route_table_ids_propagation = local.vpc_attachments[each.value]["tgw_route_table_propagation"] != null ? { "" : local.vpc_attachments[each.value]["tgw_route_table_propagation"] } : {}
  #region = var.aws_region
}
