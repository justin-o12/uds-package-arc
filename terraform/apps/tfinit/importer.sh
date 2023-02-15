#!/bin/bash
ACCOUNT_NUMBER=810783286427

terraform import aws_s3_bucket.tfbucket tfstate-dd-kb
terraform import aws_dynamodb_table.action_locktable tfstate-dd-kb-table 


