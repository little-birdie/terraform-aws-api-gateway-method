
variable "service" {
  default     = "webapi"
  type        = string
  description = "Service name"
}

variable "common_tags" {
  default     = {}
  type        = map(any)
  description = "Tags for all the module resources"
}

variable "aws_region" {
  default     = "ap-southeast-2"
  type        = string
  description = "AWS region"
}

variable "service_name" {
  default     = null
  type        = string
  description = "The Lambda name"
}

variable "aws_api_gateway_rest_api_name" {
  default     = null
  type        = string
  description = "An Optional aws api gateway to create the resources"
}

variable "description" {
  default     = null
  type        = string
  description = "Describes what this API going to do"
}

variable "environment" {
  default = "uat"
  type    = string
}

variable "parent_id" {
  default     = null
  type        = string
  description = "The path resouce where the API will be configured"
}

variable "path_part" {
  default     = null
  type        = string
  description = "The name of the path to be configured"
}

variable "resource_id" {
  default     = null
  type        = string
  description = "The resource to be used on the API"
}

variable "http_method" {
  default     = "GET"
  type        = string
  description = "The method"
}

variable "authorization" {
  default     = "NONE"
  type        = string
  description = "Enable authentication on the endpoint"
}

variable "lambda_module_version" {
  default     = "5.3.0"
  type        = string
  description = "Lambda submodule version, This project uses https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws/latest"
}

variable "handler" {
  default     = null
  type        = string
  description = "Script and main function to invoke the lambda"
}

variable "runtime" {
  default     = "python3.10"
  type        = string
  description = "What language is used on the lambda"
}

variable "timeout" {
  default     = 30
  type        = number
  description = "How long does it take to the lambda to timeout"
}

variable "memory_size" {
  default     = 256
  type        = number
  description = "Lambda memory configuration"
}

variable "external_vars" {
  type        = map(any)
  default     = {}
  description = "Lambda variables"
}

variable "layers" {
  type        = list(any)
  default     = []
  description = "Lambda layers"
}

variable "source_path" {
  type        = any
  default     = []
  description = "Lambda layers"
}

variable "cache_data_encrypted" {
  type        = bool
  default     = false
  description = "Specifies whether the cached responses are encrypted"
}

variable "cache_ttl_in_seconds" {
  type        = number
  default     = 300
  description = "Specifies the time to live (TTL), in seconds, for cached responses. The higher the TTL, the longer the response will be cached"
}

variable "caching_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether responses should be cached and returned for requests. A cache cluster must be enabled on the stage for responses to be cached"
}

variable "data_trace_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether data trace logging is enabled for this method, which affects the log entries pushed to Amazon CloudWatch Log"
}

variable "logging_level" {
  type        = string
  default     = "INFO"
  description = "Specifies the logging level for this method, which affects the log entries pushed to Amazon CloudWatch Logs. Valid values are OFF, ERROR, and INFO. Choose ERROR to write only error-level entries to CloudWatch Logs, or choose INFO to include all ERROR events as well as extra informational events"
}

variable "metrics_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether Amazon CloudWatch metrics are enabled for this method"
}

variable "require_authorization_for_cache_control" {
  type        = bool
  default     = true
  description = "Specifies whether authorization is required for a cache invalidation request"
}

variable "throttling_burst_limit" {
  type        = number
  default     = -1
  description = "Specifies the throttling burst limit"
}

variable "throttling_rate_limit" {
  type        = number
  default     = -1
  description = "Specifies the throttling rate limit"
}

variable "request_parameters" {
  default     = {}
  type        = map(any)
  description = "Map of request parameters (from the path, query string and headers) that should be passed to the integration"
}

variable "api_key_required" {
  type        = bool
  default     = false
  description = "Specify if the method requires an API key"
}

variable "unauthorized_cache_control_header_strategy" {
  type        = string
  default     = "SUCCEED_WITH_RESPONSE_HEADER"
  description = "Specifies how to handle unauthorized requests for cache invalidation"
}
