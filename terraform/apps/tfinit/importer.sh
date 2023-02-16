#!/bin/bash
ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)

terraform import aws_s3_bucket.tfbucket tfstate-dd-kb
terraform import aws_dynamodb_table.action_locktable tfstate-dd-kb-table 


