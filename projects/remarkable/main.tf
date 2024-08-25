module "network" {
  source  = "../../modules/vpc"
  egress  = false
  ingress = true
  region  = var.aws_region
  vpc     = var.vpc

}

module "ses" {
  source      = "../../modules/ses"
  domain      = "dev.potteringabout.net"
  environment = var.environment
}
