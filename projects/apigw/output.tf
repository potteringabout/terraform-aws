output "resource_one_url" {
  value = "${aws_api_gateway_rest_api.this.execution_arn}/${aws_api_gateway_deployment.this.stage_name}/resource1"
}

output "resource_two_url" {
  value = "${aws_api_gateway_rest_api.this.execution_arn}/${aws_api_gateway_deployment.this.stage_name}/resource2"
}

output "resource_three_url" {
  value = "${aws_api_gateway_rest_api.this.execution_arn}/${aws_api_gateway_deployment.this.stage_name}/resource3"
}

output "cognito_user_pool_domain" {
  value = "https://${aws_cognito_user_pool_domain.this.domain}.auth.${var.aws_region}.amazoncognito.com"
}
