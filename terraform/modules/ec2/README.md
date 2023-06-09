# Ec2 Module

Thank you to the author: 
```bash
TBD (Blame Barry)
```

Creates a simple EC2 module with Terraform

Example code for using as a module

```terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "tfstate-dd-kb"                           # Defined in terraform/apps/tfinit as a default
    key            = "statefiles/us-east-2/ec2-instance-barry" # make unique 
    region         = "us-east-2"                               # Probably not needed but add anyway
    dynamodb_table = "tfstate-dd-kb-table"
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_caller_identity" "current" {}

module "ec2_caller" {
  source = "./ec2"
  shortname = "kellifirst"
  tags = tomap({
    Name = "kellifirst"
    TEAM = "Kibbles and bits IaC test instance"
    Role = "DashDays runner instance"
  })
  vpc_id        = "vpc-0c3634632b09f272d"
  instance_type = "t3a.medium"
}
```



<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.foo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.instance_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_vpc.example_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | AWS EC2 instance type | `string` | `"t3.medium"` | no |
| <a name="input_shortname"></a> [shortname](#input\_shortname) | short name for the deployment | `string` | `"zarfbuilder"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "Role": "EC2 instance stuff",<br>  "TEAM": "dashdays-kibbles-and-bits"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | `"vpc-0a38d0e90d11c8ad4"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->