
# Declare and set some variables (Layers)
# ---------------------------------------------------

variable "python_aws_powertools" {
  type    = string
  default = "arn:aws:lambda:ap-southeast-2:017000801446:layer:AWSLambdaPowertoolsPythonV2:18"
}

# Declare tags to be applied to every resource
# ---------------------------------------------------

locals {
  common_tags = {
    Environment         = var.environment
    Maintainer_Software = "Terraform"
    Maintainer          = "nestor@littlebirdie.com.au"
    Revision            = "master"
    Project             = "https://github.com/little-birdie/terraform-aws-api-gateway-method.git"
    team                = "Core Platform"
    service_name        = "routes"
  }

}

# Create a GET method on the /api/test_events api
# gateway endpoint Triggers the src/test_event.py
# lambda function when it is called
# ---------------------------------------------------

module "test_events_get" {

  source = "../../"

  service_name  = "test-events-get"
  description   = "This is the /test_events"
  resource_id   = "/api/test_events"
  http_method   = "GET"
  authorization = "NONE"
  handler       = "get_test_event.handler"
  runtime       = "python3.9"
  timeout       = 30
  memory_size   = 256
  layers        = [var.python_aws_powertools]
  external_vars = {}
  environment   = var.environment
  common_tags   = local.common_tags

  # Specify the Lambda code base directory
  source_path = [
    "${path.module}/src/get_test_event.py",
    {
      prefix_in_zip    = "${var.environment}-get-test-events"
    }
  ]
}

module "test_events_post" {

  source = "../../"

  service_name  = "test-events-post"
  description   = "This is the /test_events"
  resource_id   = "/api/test_events"
  http_method   = "POST"
  authorization = "NONE"
  handler       = "post_test_event.handler"
  runtime       = "python3.9"
  timeout       = 30
  memory_size   = 256
  layers        = [var.python_aws_powertools]
  external_vars = {}
  environment   = var.environment
  common_tags   = local.common_tags

  # Specify the Lambda code base directory
  source_path = [
    "${path.module}/src/post_test_event.py",
    {
      prefix_in_zip    = "${var.environment}-post-test-events"
    }
  ]
}
