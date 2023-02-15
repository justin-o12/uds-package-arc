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


#### <BUCKET> ####
# S3 Bucket for the State File

resource "aws_s3_bucket" "tfbucket" {
  bucket = var.bucket_name 

  tags = tomap({
    TEAM = "dashdays-kibbles-and-bits",
    Name = "${var.bucket_name}"
    Role = "DashDays GitHub Actions runner terraform bucket for state files",
  })
}

resource "aws_s3_bucket_acl" "tfbucket_acl" {
  bucket = aws_s3_bucket.tfbucket.id
  acl    = "private"
}
### </BUCKET> ####


#### <DynamoDB Table> ####
# Dynamodb table for the lock file 
resource "aws_dynamodb_table" "action_locktable" {
  name           = "${var.bucket_name}-table" 
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  stream_enabled = false

  tags = tomap({
    TEAM = "dashdays-kibbles-and-bits",
    Name = "${var.bucket_name}-table"
    Role = "DashDays GitHub Actions runner terraform locktable",
  })

  attribute {
    name = "LockID"
    type = "S"
  }

}

#### <\DynamoDB Table> ####
