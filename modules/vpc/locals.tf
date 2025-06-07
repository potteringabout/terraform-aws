locals {

  ingress = var.vpc.ingress
  egress  = var.vpc.egress

  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  network_subnets = flatten([
    for network_key, network in var.vpc.subnets : [
      for idx, subnet in network : {
        #subnet_name       = "${network_key}${idx}"
        subnet_name       = format("%s%s", "${var.vpc.name}-${var.environment}-${network_key}-${var.region}", element(["a", "b", "c"], idx))
        cidr              = subnet.cidr
        availability_zone = format("%s%s", var.region, element(["a", "b", "c"], idx))
        zone              = network_key
      }
    ]
  ])

  access_subnets = {
    for subnet in local.network_subnets : subnet.subnet_name => subnet if subnet.zone == "access"
  }

  app_subnets = {
    for subnet in local.network_subnets : subnet.subnet_name => subnet if subnet.zone == "app"
  }
}
