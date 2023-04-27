terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "tfstate-dd-kb"
    key            = "statefiles/us-east-2/kb-zarf-runner.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tfstate-dd-kb-table"
  }
}

provider "aws" {
  region = "us-east-2"
}
