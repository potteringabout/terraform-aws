# remarkable

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tgw"></a> [tgw](#module\_tgw) | ../../modules/tgw | n/a |
| <a name="module_tgw_attach"></a> [tgw\_attach](#module\_tgw\_attach) | ../../modules/tgw-attach | n/a |
| <a name="module_vpcs"></a> [vpcs](#module\_vpcs) | ../../modules/vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | Account name abbreviation | `string` | `"prod"` | no |
| <a name="input_account_full"></a> [account\_full](#input\_account\_full) | Account name | `string` | `"Production Account"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-west-2"` | no |
| <a name="input_costcentre"></a> [costcentre](#input\_costcentre) | The cost centre to charge the asset to | `string` | `"123"` | no |
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | How the resource was deployed | `string` | `"auto"` | no |
| <a name="input_deployment_repo"></a> [deployment\_repo](#input\_deployment\_repo) | The URL of the deployment repo | `string` | n/a | yes |
| <a name="input_deployment_role_arn"></a> [deployment\_role\_arn](#input\_deployment\_role\_arn) | The ARN of role to be assumed for deployment tasks | `string` | `""` | no |
| <a name="input_email"></a> [email](#input\_email) | Email contact for the asset owner | `string` | `"platformengineering@allwyn.co.uk"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name abbreviation in lower case | `string` | `"prod"` | no |
| <a name="input_environment_full"></a> [environment\_full](#input\_environment\_full) | The environment name in full | `string` | `"Production environment for shared services"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The individual or team owner of the asset | `string` | `"Platform Engineering"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project abbreviation in lower case | `string` | `"ss"` | no |
| <a name="input_project_full"></a> [project\_full](#input\_project\_full) | The project name in full | `string` | `"Shared Services"` | no |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | n/a | <pre>map(object(<br>    {<br>      cidr    = string<br>      name    = string<br>      ingress = bool<br>      egress  = bool<br>      subnets = map(<br>        list(<br>          object(<br>            {<br>              cidr = string<br>            }<br>          )<br>        )<br>      )<br>    }<br>  ))</pre> | <pre>{<br>  "app": {<br>    "cidr": "10.0.0.0/16",<br>    "egress": false,<br>    "ingress": true,<br>    "name": "app",<br>    "subnets": {<br>      "access": [<br>        {<br>          "cidr": "10.0.0.0/25"<br>        },<br>        {<br>          "cidr": "10.0.0.128/25"<br>        }<br>      ],<br>      "app": [<br>        {<br>          "cidr": "10.0.2.0/25"<br>        },<br>        {<br>          "cidr": "10.0.2.128/25"<br>        }<br>      ],<br>      "data": [<br>        {<br>          "cidr": "10.0.1.0/25"<br>        },<br>        {<br>          "cidr": "10.0.1.128/25"<br>        }<br>      ],<br>      "fw": [<br>        {<br>          "cidr": "10.0.4.0/25"<br>        },<br>        {<br>          "cidr": "10.0.4.128/25"<br>        }<br>      ],<br>      "tgw": [<br>        {<br>          "cidr": "10.0.3.0/25"<br>        },<br>        {<br>          "cidr": "10.0.3.128/25"<br>        }<br>      ]<br>    }<br>  },<br>  "egress": {<br>    "cidr": "10.2.0.0/16",<br>    "egress": true,<br>    "ingress": false,<br>    "name": "egress",<br>    "subnets": {<br>      "egress": [<br>        {<br>          "cidr": "10.2.0.0/25"<br>        },<br>        {<br>          "cidr": "10.2.0.128/25"<br>        }<br>      ],<br>      "tgw": [<br>        {<br>          "cidr": "10.2.1.0/25"<br>        },<br>        {<br>          "cidr": "10.2.1.128/25"<br>        }<br>      ]<br>    }<br>  },<br>  "inspection": {<br>    "cidr": "10.1.0.0/16",<br>    "egress": false,<br>    "ingress": false,<br>    "name": "inspection",<br>    "subnets": {<br>      "inspection": [<br>        {<br>          "cidr": "10.1.0.0/25"<br>        },<br>        {<br>          "cidr": "10.1.0.128/25"<br>        }<br>      ],<br>      "tgw": [<br>        {<br>          "cidr": "10.1.1.0/25"<br>        },<br>        {<br>          "cidr": "10.1.1.128/25"<br>        }<br>      ]<br>    }<br>  }<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
