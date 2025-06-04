// Mandatory vars
variable "deployment_role_arn" {
  description = "The ARN of role to be assumed for deployment tasks"
  default     = ""
  type        = string
}

/*variable "dns_role_arn" {
  description = "The ARN of role to be assumed for DNS updates"
  default     = ""
  type        = string
}*/


variable "aws_region" {
  default = "eu-west-2"
  type    = string
}

/*variable "deploy_region" {
  type = string
}*/

// Tags - https://allwynuk.atlassian.net/wiki/spaces/DevOps/pages/135758056/Tagging
variable "account" {
  description = "Account name abbreviation"
  default     = "prod"
  type        = string
}

variable "account_full" {
  description = "Account name"
  default     = "Production Account"
  type        = string
}

variable "costcentre" {
  description = "The cost centre to charge the asset to"
  default     = "123" // TODO: Confirm appropriate value
  type        = string
}

variable "deployment_mode" {
  description = "How the resource was deployed"
  default     = "auto"
  type        = string
}

variable "deployment_repo" {
  description = "The URL of the deployment repo"
  type        = string
}

variable "email" {
  description = "Email contact for the asset owner"
  default     = "platformengineering@allwyn.co.uk" // TODO: Confirm appropriate value
  type        = string
}

variable "environment" {
  description = "Environment name abbreviation in lower case"
  default     = "prod"
  type        = string
}

variable "environment_full" {
  description = "The environment name in full"
  default     = "Production environment for shared services"
  type        = string
}

variable "owner" {
  description = "The individual or team owner of the asset"
  default     = "Platform Engineering" // TODO: Confirm appropriate value
  type        = string
}

variable "project" {
  description = "Project abbreviation in lower case"
  default     = "ss"
  type        = string
}

variable "project_full" {
  description = "The project name in full"
  default     = "Shared Services"
  type        = string
}


variable "vpc" {
  type = object(
    {
      cidr    = string
      name    = string
      ingress = bool
      egress  = bool
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

  default = {
    cidr    = "10.0.0.0/16"
    name    = "blah"
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
    }

  }
}
