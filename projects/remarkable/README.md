# remarkable

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ../../modules/lambda | n/a |
| <a name="module_lambda2"></a> [lambda2](#module\_lambda2) | ../../modules/lambda | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/vpc | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ../../modules/s3 | n/a |
| <a name="module_ses"></a> [ses](#module\_ses) | ../../modules/ses | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ses_active_receipt_rule_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_active_receipt_rule_set) | resource |
| [aws_ses_receipt_rule.store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_rule) | resource |
| [aws_ses_receipt_rule_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_receipt_rule_set) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda2_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

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
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | `"dev.potteringabout.net"` | no |
| <a name="input_email"></a> [email](#input\_email) | Email contact for the asset owner | `string` | `"platformengineering@allwyn.co.uk"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name abbreviation in lower case | `string` | `"prod"` | no |
| <a name="input_environment_full"></a> [environment\_full](#input\_environment\_full) | The environment name in full | `string` | `"Production environment for shared services"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | The individual or team owner of the asset | `string` | `"Platform Engineering"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project abbreviation in lower case | `string` | `"ss"` | no |
| <a name="input_project_full"></a> [project\_full](#input\_project\_full) | The project name in full | `string` | `"Shared Services"` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | n/a | <pre>object(<br>    {<br>      cidr = string<br>      name = string<br>      subnets = map(<br>        list(<br>          object(<br>            {<br>              cidr = string<br>            }<br>          )<br>        )<br>      )<br>    }<br>  )</pre> | <pre>{<br>  "cidr": "10.0.0.0/16",<br>  "egress": false,<br>  "ingress": true,<br>  "name": "blah",<br>  "subnets": {<br>    "access": [<br>      {<br>        "cidr": "10.0.0.0/25"<br>      },<br>      {<br>        "cidr": "10.0.0.128/25"<br>      }<br>    ],<br>    "app": [<br>      {<br>        "cidr": "10.0.2.0/25"<br>      },<br>      {<br>        "cidr": "10.0.2.128/25"<br>      }<br>    ],<br>    "data": [<br>      {<br>        "cidr": "10.0.1.0/25"<br>      },<br>      {<br>        "cidr": "10.0.1.128/25"<br>      }<br>    ]<br>  }<br>}</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
