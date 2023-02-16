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


