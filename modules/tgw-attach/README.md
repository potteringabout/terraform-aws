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
| [aws_ec2_transit_gateway_route.static_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_propagation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_propagation) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The subnet ids where the TGW attachments will be created | `list(string)` | n/a | yes |
| <a name="input_tgw_attachment_name"></a> [tgw\_attachment\_name](#input\_tgw\_attachment\_name) | Name of the attachment | `string` | n/a | yes |
| <a name="input_tgw_route_table_id_association"></a> [tgw\_route\_table\_id\_association](#input\_tgw\_route\_table\_id\_association) | The route tables with which to assocate the attachment | `string` | n/a | yes |
| <a name="input_tgw_route_table_ids_propagation"></a> [tgw\_route\_table\_ids\_propagation](#input\_tgw\_route\_table\_ids\_propagation) | The route tables to which we propagate assocaited with this attachment to | `list(string)` | `[]` | no |
| <a name="input_tgw_static_routes"></a> [tgw\_static\_routes](#input\_tgw\_static\_routes) | The list of static routes handled by this attachment. The routes will be propagated to the route tables in the tgw\_route\_table\_ids\_propagation list | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc id to associate with the TGW | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_inbound_route_table_id"></a> [inbound\_route\_table\_id](#output\_inbound\_route\_table\_id) | The ID of the inbound route table |
| <a name="output_outbound_route_table_id"></a> [outbound\_route\_table\_id](#output\_outbound\_route\_table\_id) | The ID of the outbound route table |
| <a name="output_transit_gateway_arn"></a> [transit\_gateway\_arn](#output\_transit\_gateway\_arn) | The ARN of the created Transit Gateway |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | The ID of the created Transit Gateway |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
