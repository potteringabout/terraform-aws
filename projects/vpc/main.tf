module "network" {
  source  = "../../modules/vpc"
  egress  = false
  ingress = true
  region  = var.aws_region
  vpc     = var.vpc

}
