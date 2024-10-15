module "vpcs" {
  source = "../../modules/vpc"
  for_each = {
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

  region = var.aws_region
  vpc    = each.value
}


module "tgw" {
  source       = "../../modules/tgw"
  tgw_name     = "tgw"
  route_tables = ["inbound", "inspection"]
  #region = var.aws_region
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

/*module "tgw_attach" {
  source   = "../../modules/tgw-attach"
  tgw_attachment_name = "tgw"
  #region = var.aws_region
}*/
