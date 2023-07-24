
resource "aws_api_gateway_method" "main" {
  rest_api_id          = data.aws_api_gateway_rest_api.main.id
  resource_id          = data.aws_api_gateway_resource.main.id
  http_method          = var.http_method
  authorization        = var.authorization
  api_key_required     = var.api_key_required
  request_parameters   = var.request_parameters
  request_validator_id = aws_api_gateway_request_validator.main[0].id
}

resource "aws_api_gateway_method_settings" "main" {
  rest_api_id = data.aws_api_gateway_rest_api.main.id
  stage_name  = var.environment
  method_path = "${trimprefix(data.aws_api_gateway_resource.main.path, "/")}/${aws_api_gateway_method.main.http_method}"


  settings {
    cache_data_encrypted                       = var.cache_data_encrypted
    cache_ttl_in_seconds                       = var.cache_ttl_in_seconds
    caching_enabled                            = var.caching_enabled
    data_trace_enabled                         = var.data_trace_enabled
    logging_level                              = var.logging_level
    metrics_enabled                            = var.metrics_enabled
    require_authorization_for_cache_control    = var.require_authorization_for_cache_control
    throttling_burst_limit                     = var.throttling_burst_limit
    throttling_rate_limit                      = var.throttling_rate_limit
    unauthorized_cache_control_header_strategy = var.unauthorized_cache_control_header_strategy
  }

}

resource "aws_api_gateway_integration" "main" {
  rest_api_id             = data.aws_api_gateway_rest_api.main.id
  resource_id             = data.aws_api_gateway_resource.main.id
  http_method             = aws_api_gateway_method.main.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.main_lambda.lambda_function_invoke_arn
}

resource "aws_api_gateway_request_validator" "main" {
  count                       = length(var.request_parameters) > 0 ? 1 : 0
  name                        = "${var.environment}-${var.service_name}-${var.http_method}"
  rest_api_id                 = data.aws_api_gateway_rest_api.main.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_lambda_permission" "main_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.main_lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${data.aws_api_gateway_rest_api.main.execution_arn}/*"
}

module "main_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "5.3.0"

  function_name = "${var.environment}-${var.service_name}"
  description   = var.description
  handler       = var.handler
  runtime       = var.runtime
  publish       = true
  timeout       = var.timeout
  memory_size   = var.memory_size

  source_path = [
    {
      path = "${path.module}/../../../",
      patterns = [
        "!.*/*",
        "src/.+",
      ]
    }
  ]

  vpc_subnet_ids         = data.aws_subnets.private.ids
  vpc_security_group_ids = [data.aws_security_group.main.id]
  attach_network_policy  = true

  policy        = data.aws_iam_policy.main.arn
  attach_policy = true

  environment_variables = var.external_vars
  attach_tracing_policy = true

  layers = var.layers

  tags = var.common_tags
}
