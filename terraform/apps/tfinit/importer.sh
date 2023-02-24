#!/bin/bash
ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)

terraform import aws_s3_bucket.tfbucket                               tfstate-dd-kb
terraform import aws_dynamodb_table.action_locktable                  tfstate-dd-kb-table 
terraform import aws_iam_instance_profile.edafos_instance_profile     edafos-Profile
terraform import aws_iam_role.edafos-instance                         edafos-role
terraform import aws_iam_policy.s3_bucket                             arn:aws:iam::${ACCOUNT_NUMBER}:policy/edafos-s3-policy 
terraform import aws_iam_policy.dynamo-rw                             arn:aws:iam::${ACCOUNT_NUMBER}:policy/edafos-dynamo-policy

