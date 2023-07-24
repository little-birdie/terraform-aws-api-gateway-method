

<div align="center">
<img src="https://www.littlebirdie.com.au/static/media/littlebirdie-logo-nav.df8831a6.svg" alt="logo"></img>
</div>



## Provision Instructions

```hcl
module "api-gateway-method" {
  source  = "little-birdie/api-gateway-method/aws"
  version = "0.0.3"
}
```

Terraform registry: [https://registry.terraform.io/modules/little-birdie/api-gateway-method/aws/latest](https://registry.terraform.io/modules/little-birdie/api-gateway-method/aws/latest)

Little Birdie's internal terraform module which creates an API Gateway method to an already existent API gateway

## Complete example

```hcl
# Declare and set some variables (Layers)
# ---------------------------------------------------

variable "python_aws_powertools" {
  type    = string
  default = "arn:aws:lambda:ap-southeast-2:017000801446:layer:AWSLambdaPowertoolsPythonV2:18"
}

variable "python_sentry_layer" {
  type    = string
  default = "arn:aws:lambda:ap-southeast-2:943013980633:layer:SentryPythonServerlessSDK:47"
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

  service_name  = "test-events"
  description   = "This is the /test_events"
  resource_id   = "/api/test_events"
  http_method   = "GET"
  authorization = "NONE"
  handler       = "src/test_event.handler"
  runtime       = "python3.9"
  timeout       = 30
  memory_size   = 256
  layers        = [var.python_aws_powertools, var.python_sentry_layer]
  external_vars = var.external_vars
  environment   = var.environment
  common_tags   = local.common_tags
}
```