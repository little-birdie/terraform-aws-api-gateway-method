output "rest_api_id" {
  value = data.aws_api_gateway_rest_api.main.id
}

output "aws_region" {
  value = var.aws_region
}
