variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc" {
  type = object(
    {
      cidr    = string
      name    = string
      egress  = bool
      ingress = bool
      subnets = map(
        list(
          object(
            {
              cidr = string
            }
          )
        )
      )
    }
  )
  validation {
    condition     = can(cidrhost(var.vpc.cidr, 32))
    error_message = "Invalid vpc cidr"
  }

  validation {
    condition = alltrue(flatten([
      for k, v in var.vpc.subnets :
      [for ki, vi in v : can(cidrhost(vi.cidr, 32))]
    ]))
    error_message = "Subnet cidr invalid" # can't use local var here either
  }
}
