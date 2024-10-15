/*variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-west-2"
}*/

variable "tgw_name" {
  description = "The name of the Transit Gateway"
  type        = string
}

variable "amazon_side_asn" {
  description = "The ASN for the Amazon side of the gateway"
  type        = number
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  description = "Whether to automatically accept shared attachments"
  type        = string
  default     = "disable"
}

variable "default_route_table_association" {
  description = "Whether to automatically associate attachments with the default route table"
  type        = string
  default     = "disable"
}

variable "default_route_table_propagation" {
  description = "Whether to automatically propagate routes to the default route table"
  type        = string
  default     = "disable"
}

variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "My Transit Gateway"
}

variable "dns_support" {
  description = "Whether DNS support is enabled"
  type        = string
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Whether VPN ECMP support is enabled"
  type        = string
  default     = "enable"
}

variable "route_tables" {
  description = "List of route tables to create and associate with the TGW"
  type        = list(string)
}
