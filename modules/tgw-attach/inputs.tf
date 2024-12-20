variable "tgw_id" {
  type        = string
  description = "Id of the Transit Gateway"
}

variable "tgw_attachment_name" {
  type        = string
  description = "Name of the attachment"
}

variable "vpc_id" {
  type        = string
  description = "The vpc id to associate with the TGW"
}

variable "subnet_ids" {
  type        = set(string)
  description = "The subnet ids where the TGW attachments will be created"
}

variable "tgw_route_table_id_association" {
  type        = string
  description = "The route tables with which to assocate the attachment"
}

variable "tgw_route_table_id_propagation" {
  type        = string
  description = "The route tables to which we propagate assocaited with this attachment to"
  default     = null
}

variable "tgw_static_routes" {
  type        = set(string)
  description = "The map of static routes handled by this attachment. The routes will be propagated to the route tables in the tgw_route_table_ids_propagation map"
  default     = []
}
