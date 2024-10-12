module "network" {
  source = "../../modules/vpc"
  region = var.aws_region
  vpc    = var.vpc
}
