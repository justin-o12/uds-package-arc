terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "tfstate-dd-kb-20230608200916573100000001"
    key            = "statefiles/us-east-2/zarfinstance.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tfstate-dd-kb-table"
  }
}

provider "aws" {
  region = "us-east-2"
}
