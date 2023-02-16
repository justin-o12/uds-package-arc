terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

terraform {
  backend "s3" {
    bucket         = "tfstate-dd-kb"                              # Defined in terraform/apps/tfinit as a default
    key            = "statefiles/us-east-2/example-github-runner" # make unique 
    region         = "us-east-2"                                  # Probably not needed but add anyway
    dynamodb_table = "tfstate-dd-kb-table"
  }
}

