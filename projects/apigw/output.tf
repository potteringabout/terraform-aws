output "api_url" {
  value = "${aws_api_gateway_rest_api.this.execution_arn}/${aws_api_gateway_deployment.this.stage_name}/example"
}
