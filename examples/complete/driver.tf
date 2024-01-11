terraform {
  required_version = "= 1.5.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "edge"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_canonical_user_id" "current" {}
