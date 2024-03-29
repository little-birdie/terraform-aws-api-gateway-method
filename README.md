

<div align="center">
<img src="https://www.littlebirdie.com.au/static/media/littlebirdie-logo-nav.df8831a6.svg" alt="logo"></img>
</div>


Terraform registry: [https://registry.terraform.io/modules/little-birdie/api-gateway-method/aws/latest](https://registry.terraform.io/modules/little-birdie/api-gateway-method/aws/latest)

Little Birdie's internal terraform module which creates an API Gateway method to an already existent API gateway

## Provision Instructions

```hcl
module "api-gateway-method" {
  source  = "little-birdie/api-gateway-method/aws"
  version = "0.0.14"
}
```

## Complete example

```hcl
# Declare and set some variables (Layers)
# ---------------------------------------------------

variable "python_aws_powertools" {
  type    = string
  default = "arn:aws:lambda:ap-southeast-2:017000801446:layer:AWSLambdaPowertoolsPythonV2:18"
}

# Extenal variables to be injected to lambda functions
# ---------------------------------------------------

external_vars = {
  "DEPLOY_ENV"       = "uat",
  "REGION"           = "ap-southeast-2",
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

module "test_events" {

  source = "../../"

  # Set the name of the API Gateway where you want to attach the new resources
  aws_api_gateway_rest_api_name = "test-api-gateway"

  service_name  = "test-events"
  description   = "This is the /test_events"

  # The resource id below is not created by this module, you'll need to use something similar to:
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_resource
  resource_id   = "/api/test_events"

  http_method   = "GET"
  authorization = "NONE"
  handler       = "get_test_event.handler"
  runtime       = "python3.9"
  timeout       = 30
  memory_size   = 256
  layers        = [var.python_aws_powertools]
  external_vars = var.external_vars
  environment   = var.environment
  common_tags   = local.common_tags

  # Specify the Lambda code base directory
  source_path = [
    "${path.module}/src/get_test_event.py",
    {
      prefix_in_zip    = "${var.environment}-get-test-events"
    }
  ]

  request_parameters = {
    "method.request.path.proxy" = true
    "method.request.header.X-Some-Header" = true
    "method.request.querystring.my_id" = true
  }
}
```
