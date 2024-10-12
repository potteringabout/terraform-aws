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
