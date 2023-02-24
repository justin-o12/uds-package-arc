# Terraform Init

Basics needed for setting up the Terraform Backend using an s3 bucket and a dynamodb table.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.action_locktable](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_instance_profile.edafos_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.dynamo-rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.edafos-instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_s3_bucket.tfbucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.tfbucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_iam_policy.AdministratorAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.ReadOnlyAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region for deployment | `string` | `"us-east-2"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of the Terraform Bucket | `string` | `"tfstate-dd-kb"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags, always tag | `map(string)` | <pre>{<br>  "Role": "DD KB Terraform Actions Init",<br>  "TEAM": "dashdays-kibbles-and-bits"<br>}</pre> | no |
| <a name="input_shortname"></a> [shortname](#input\_shortname) | Some simple short and profound name | `string` | `"edafos"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lock_table"></a> [lock\_table](#output\_lock\_table) | Dynamodb Locktable |
| <a name="output_tfbucket"></a> [tfbucket](#output\_tfbucket) | TF Bucket Name |
<!-- END_TF_DOCS -->
