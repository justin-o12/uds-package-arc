terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
	  region = "us-east-2"
    }
  }
  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "tfstate-dd-kb"
    key            = "statefiles/us-east-2/zarfinstance.tfstate"
    region         = "us-east-2"
    dynamodb_table = "tfstate-dd-kb-table"
  }
}
