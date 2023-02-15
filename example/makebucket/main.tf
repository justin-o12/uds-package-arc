#### <AWS Provider> ####
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = local.aws_region
}

#### </AWS Provider> ####

#### <TF Backend> ####
terraform {
  backend "s3" {
    bucket = "tfstate-dd-kb"                       # Defined in terraform/apps/tfinit as a default
    key    = "statefiles/us-east-2/example-bucket" # make unique 
    region = "us-east-2"                           # Probably not needed but add anyway
	dynamodb_table = "tfstate-dd-kb-table"
  }
}

#### <TF Backend> ####


locals {
  bucket_name = "simple-delete-me-please"
  aws_region  = "us-east-2" # Mike can walk there
}


#### <BUCKET> ####
# S3 Bucket for the State File

resource "aws_s3_bucket" "tfbucket" {
  bucket = local.bucket_name

  tags = tomap({
    TEAM = "dashdays-kibbles-and-bits",
    Description = "sample bucket kibles and bits"
    Role = "Example deployment bucket can delete"
  })
}

resource "aws_s3_bucket_acl" "tfbucket_acl" {
  bucket = aws_s3_bucket.tfbucket.id
  acl    = "private"
}
### </BUCKET> ####
