# Terraform Init

Basics needed for setting up the Terraform Backend using an s3 bucket and a dynamodb table.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.action_locktable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_s3_bucket.tfbucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.tfbucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region for deployment | `string` | `"us-east-2"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the Terraform Bucket | `string` | `"tfstate-dd-kb"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lock_table"></a> [lock\_table](#output\_lock\_table) | Dynamodb Locktable |
| <a name="output_tfbucket"></a> [tfbucket](#output\_tfbucket) | TF Bucket Name |
