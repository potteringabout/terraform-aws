# tgw

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazon_side_asn"></a> [amazon\_side\_asn](#input\_amazon\_side\_asn) | The ASN for the Amazon side of the gateway | `number` | `64512` | no |
| <a name="input_auto_accept_shared_attachments"></a> [auto\_accept\_shared\_attachments](#input\_auto\_accept\_shared\_attachments) | Whether to automatically accept shared attachments | `string` | `"disable"` | no |
| <a name="input_default_route_table_association"></a> [default\_route\_table\_association](#input\_default\_route\_table\_association) | Whether to automatically associate attachments with the default route table | `string` | `"disable"` | no |
| <a name="input_default_route_table_propagation"></a> [default\_route\_table\_propagation](#input\_default\_route\_table\_propagation) | Whether to automatically propagate routes to the default route table | `string` | `"disable"` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the Transit Gateway | `string` | `"My Transit Gateway"` | no |
| <a name="input_dns_support"></a> [dns\_support](#input\_dns\_support) | Whether DNS support is enabled | `string` | `"enable"` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | List of route tables to create and associate with the TGW | `list(string)` | n/a | yes |
| <a name="input_tgw_name"></a> [tgw\_name](#input\_tgw\_name) | The name of the Transit Gateway | `string` | n/a | yes |
| <a name="input_vpn_ecmp_support"></a> [vpn\_ecmp\_support](#input\_vpn\_ecmp\_support) | Whether VPN ECMP support is enabled | `string` | `"enable"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | The route tables |
| <a name="output_transit_gateway_arn"></a> [transit\_gateway\_arn](#output\_transit\_gateway\_arn) | The ARN of the created Transit Gateway |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | The ID of the created Transit Gateway |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
