data "aws_api_gateway_rest_api" "main" {

  name = "${var.environment}-${var.service}"
}

data "aws_api_gateway_resource" "main" {
  rest_api_id = data.aws_api_gateway_rest_api.main.id
  path        = var.resource_id
}

data "aws_iam_policy" "main" {
  name = "${var.environment}-${var.service}-ecs-iam-policy"
}

data "aws_vpc" "current" {
  filter {
    name   = "tag:Name"
    values = ["${var.environment}-api"]
  }

  filter {
    name   = "tag:Environment"
    values = ["${var.environment}"]
  }

  filter {
    name   = "tag:service_name"
    values = ["${var.service}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.environment}-api-private-*"]
  }

}

data "aws_security_group" "main" {
  name = "${var.environment}-${var.service}-lambdas"
}
