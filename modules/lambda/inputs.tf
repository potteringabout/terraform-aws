/*variable "project" {
  type = string
}

variable "environment" {
  type = string
}*/

variable "function_name" {
  type = string
}

variable "function_handler" {
  type = string
}

variable "function_dir" {
  type = string
}

variable "function_runtime" {
  type = string
}

variable "function_policy_json" {
  type = string
}

variable "function_exec_arn" {
  type = string
}

variable "function_exec_service" {
  type = string
}

variable "funtion_timeout" {
  type    = number
  default = 10
}
