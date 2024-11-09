resource "aws_cognito_user_pool" "this" {
  name = "example-user-pool"
}

resource "aws_cognito_user_pool_client" "this" {
  name                                 = "example-user-pool-client"
  user_pool_id                         = aws_cognito_user_pool.this.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile"]
  generate_secret                      = false
}

resource "aws_api_gateway_rest_api" "this" {
  #checkov:skip=CKV_AWS_237: "Ensure Create before destroy for API Gateway"
  name = "example-api"
}

resource "aws_api_gateway_resource" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "this" {
  #checkov:skip=CKV2_AWS_53: "Ensure AWS API gateway request is validated"
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.this.id
}

resource "aws_api_gateway_authorizer" "this" {
  name            = "example-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.this.id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [aws_cognito_user_pool.this.arn]
  identity_source = "method.request.header.Authorization"
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.this.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.this.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "{\"message\": \"Hello from your mock API!\"}"
  }
}

resource "aws_api_gateway_method_response" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.this.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_deployment" "this" {
  #checkov:skip=CKV_AWS_217: "Ensure Create before destroy for API deployments"
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "test"
}
