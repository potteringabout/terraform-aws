resource "aws_cognito_user_pool" "this" {
  name = "example-user-pool"
}

# Client 1 with access to all resources (generate_secret set to true)
resource "aws_cognito_user_pool_client" "client_all_resources" {
  name                                 = "client-all-resources"
  user_pool_id                         = aws_cognito_user_pool.this.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = ["openid"]
  generate_secret                      = true # Set to true for client_credentials flow
}

# Client 2 with access to only the first resource (generate_secret set to true)
resource "aws_cognito_user_pool_client" "client_first_resource" {
  name                                 = "client-first-resource"
  user_pool_id                         = aws_cognito_user_pool.this.id
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = ["openid"]
  generate_secret                      = true # Set to true for client_credentials flow
}

resource "aws_api_gateway_rest_api" "this" {
  #checkov:skip=CKV_AWS_237: "Ensure Create before destroy for API Gateway"
  name = "example-api"
}

# Resource 1
resource "aws_api_gateway_resource" "resource_one" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "resource1"
}

# Resource 2
resource "aws_api_gateway_resource" "resource_two" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "resource2"
}

# Resource 3
resource "aws_api_gateway_resource" "resource_three" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "resource3"
}

# Resource 1 method (GET) requiring API key
resource "aws_api_gateway_method" "method_one" {
  #checkov:skip=CKV2_AWS_53: "Ensure AWS API gateway request is validated"
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_resource.resource_one.id
  http_method      = "GET"
  authorization    = "COGNITO_USER_POOLS"
  authorizer_id    = aws_api_gateway_authorizer.this.id
  api_key_required = true # Require API key
}

# Resource 2 method (GET) requiring API key
resource "aws_api_gateway_method" "method_two" {
  #checkov:skip=CKV2_AWS_53: "Ensure AWS API gateway request is validated"
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_resource.resource_two.id
  http_method      = "GET"
  authorization    = "COGNITO_USER_POOLS"
  authorizer_id    = aws_api_gateway_authorizer.this.id
  api_key_required = true # Require API key
}

# Resource 3 method (GET) requiring API key
resource "aws_api_gateway_method" "method_three" {
  #checkov:skip=CKV2_AWS_53: "Ensure AWS API gateway request is validated"
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_resource.resource_three.id
  http_method      = "GET"
  authorization    = "COGNITO_USER_POOLS"
  authorizer_id    = aws_api_gateway_authorizer.this.id
  api_key_required = true # Require API key
}

resource "aws_api_gateway_authorizer" "this" {
  name            = "example-authorizer"
  rest_api_id     = aws_api_gateway_rest_api.this.id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [aws_cognito_user_pool.this.arn]
  identity_source = "method.request.header.Authorization"
}

# Mock integration for Resource 1
resource "aws_api_gateway_integration" "integration_one" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.resource_one.id
  http_method = aws_api_gateway_method.method_one.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_one" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.resource_one.id
  http_method = aws_api_gateway_method.method_one.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "{\"message\": \"Hello from Resource 1!\"}"
  }
}

# Mock integration for Resource 2
resource "aws_api_gateway_integration" "integration_two" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.resource_two.id
  http_method = aws_api_gateway_method.method_two.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_two" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.resource_two.id
  http_method = aws_api_gateway_method.method_two.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "{\"message\": \"Hello from Resource 2!\"}"
  }
}

# Mock integration for Resource 3
resource "aws_api_gateway_integration" "integration_three" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.resource_three.id
  http_method = aws_api_gateway_method.method_three.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_three" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.resource_three.id
  http_method = aws_api_gateway_method.method_three.http_method
  status_code = "200"

  response_templates = {
    "application/json" = "{\"message\": \"Hello from Resource 3!\"}"
  }
}

resource "aws_api_gateway_deployment" "this" {
  #checkov:skip=CKV_AWS_217: "Ensure Create before destroy for API deployments"
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "test"
}



# API Key for Client 1 (Full Access)
resource "aws_api_gateway_api_key" "client_all_resources" {
  name    = "client-all-resources-key"
  enabled = true
}

# API Key for Client 2 (Limited Access to Resource 1)
resource "aws_api_gateway_api_key" "client_first_resource" {
  name    = "client-first-resource-key"
  enabled = true
}

# Usage Plan for Client 1 (Access to all resources)
resource "aws_api_gateway_usage_plan" "full_access_plan" {
  name = "full-access-plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_deployment.this.stage_name
  }
}

# Usage Plan for Client 2 (Access to only Resource 1)
resource "aws_api_gateway_usage_plan" "limited_access_plan" {
  name = "limited-access-plan"
  # Only associate this usage plan with the method for Resource 1
  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_deployment.this.stage_name
    throttle {
      path        = "/resource1/GET" # Limit to Resource 1 GET method
      burst_limit = 100
      rate_limit  = 50
    }
  }
}

# Attach Client 1's API Key to the Full Access Plan
resource "aws_api_gateway_usage_plan_key" "client_all_resources_key" {
  key_id        = aws_api_gateway_api_key.client_all_resources.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.full_access_plan.id
}

# Attach Client 2's API Key to the Limited Access Plan
resource "aws_api_gateway_usage_plan_key" "client_first_resource_key" {
  key_id        = aws_api_gateway_api_key.client_first_resource.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.limited_access_plan.id
}
