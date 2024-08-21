# s3

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | 2.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.5.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/2.5.0/docs/data-sources/file) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_function_dir"></a> [function\_dir](#input\_function\_dir) | n/a | `string` | n/a | yes |
| <a name="input_function_exec_arn"></a> [function\_exec\_arn](#input\_function\_exec\_arn) | n/a | `string` | n/a | yes |
| <a name="input_function_exec_service"></a> [function\_exec\_service](#input\_function\_exec\_service) | n/a | `string` | n/a | yes |
| <a name="input_function_handler"></a> [function\_handler](#input\_function\_handler) | n/a | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | n/a | `string` | n/a | yes |
| <a name="input_function_policy_json"></a> [function\_policy\_json](#input\_function\_policy\_json) | n/a | `string` | n/a | yes |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | n/a | `string` | n/a | yes |
| <a name="input_funtion_timeout"></a> [funtion\_timeout](#input\_funtion\_timeout) | n/a | `number` | `10` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
