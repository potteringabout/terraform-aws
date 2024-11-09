output "api_url" {
  value = "${aws_api_gateway_rest_api.example.execution_arn}/${aws_api_gateway_deployment.example.stage_name}/example"
}
