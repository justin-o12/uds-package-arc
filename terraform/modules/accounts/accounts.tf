terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = vars.aws_region
}

locals {
  # instance_profile_name = "Spokafos-Profile"
  shortname     = "Edafos"
  accountNumber = data.aws_caller_identity.current.account_id
  local_iam_policies = [
    aws_iam_policy.edafos-cfn.arn,
    aws_iam_policy.edafos-assumeDeveloper.arn,
    # aws_iam_policy.edafos-putparameter.arn,
    aws_iam_policy.edafos-dynamo.arn,
    aws_iam_policy.edafos-terraform.arn,
    data.aws_iam_policy.putparameter.arn,
    # data.aws_iam_policy.edafos-dynmo.arn,
    data.aws_iam_policy.ReadOnlyAccess.arn,
    data.aws_iam_policy.AdministratorAccess.arn,
    # data.aws_iam_policy.edafos-terraform.arn,
    # data.aws_iam_policy.s3_putobject.arn,
    data.aws_iam_policy.AssumeRole.arn,
  ]
}

resource "aws_iam_instance_profile" "edafos_instance_profile" {
  name = "${local.shortname}-Profile"
  role = aws_iam_role.edafos-instance.name
}

resource "aws_iam_role" "edafos-instance" {
  name                = "${local.shortname}-Role"
  managed_policy_arns = local.local_iam_policies
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "edafos-cfn" {
  name = "${local.shortname}-Instance-CFN"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::*"
      },
      {
        Action = [
          "cloudwatch:DisableAlarmActions",
          "cloudwatch:EnableAlarmActions",
          "cloudwatch:PutMetricAlarm",
          "cloudwatch:PutMetricData",
          "cloudwatch:SetAlarmState",
        ]
        Effect = "Allow"
        Resource : "*"
      },
      {
        Action = [
          "autoscaling:*",
          "sns:List*",
          "ec2:MonitorInstances"
        ]
        Effect = "Allow"
        Resource : "*"
      },
      #      {
      #        Action = [
      #          "sns:Publish",
      #        ]
      #        Resource : "arn:aws:sns:us-east-1:${local.accountNumber}:Monitoring*"
      #        "Effect" = "Allow"
      #        "Sid" : "SNSPublishMonitoring"
      #      },
    ]
  })
}

resource "aws_iam_policy" "edafos-terraform" {
  name = "terraformexecution"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action : "sts:AssumeRole",
        Resource : "arn:aws:iam::*:role/TerraformExecutionRole"
        Effect = "Allow"
      },
    ]
  })
}


resource "aws_iam_policy" "edafos-assumeDeveloper" {
  name = "AssumeRole${local.shortname}Developer"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Resource = [
          # "arn:aws:iam::${local.accountNumber}:role/core-tech-cloud-infra-developer",
          # "arn:aws:iam::${local.accountNumber}:role/core-tech-cloud-infra-administrator"
          "arn:aws:iam::${local.accountNumber}:role/OrganizationAccountAccessRole",
        ]
        Action = "sts:AssumeRole"
        Effect = "Allow"
      },
      {
        Resource = [
          "arn:aws:iam::${local.accountNumber}:role/OrganizationAccountAccessRole",
        ]
        Action = "iam:PassRole"
        Effect = "Allow"
      },
      #      {
      #        Action = [
      #          "arn:aws:iam::${local.accountNumber}:role/Edafos*",
      #          "arn:aws:iam::${local.accountNumber}:role/edafos*",
      #          "arn:aws:iam::${local.accountNumber}:instance-profile/Edafos*",
      #          "arn:aws:iam::${local.accountNumber}:instance-profile/edafos*"
      #        ]
      #        Action : "iam:PassRole"
      #        Effect = "Allow"
      #      },
    ]
  })
}

resource "aws_iam_policy" "edafos-dynamo" {
  name = "${local.shortname}_s3_dynamodb_readwrite"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
          "dynamodb:*",
        ]
        Resource = "*"
        Effect   = "Allow"
        Sid      = "TerraformEditor0"
      },
    ]
  })
}

resource "aws_iam_policy" "edafos-putparameter" {
  name        = "PutParameter"
  description = "PutParameter"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:PutParameter",
          "ssm:DeleteParameter",
        ]
        Sid      = "VisualEditor0"
        Effect   = "Allow"
        Resource = "arn:aws:ssm:*:${local.accountNumber}:parameter/*"
      },
    ]
  })
}

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "putparameter" {
  arn = "arn:aws:iam::${local.accountNumber}:policy/PutParameter"
}

# data "aws_iam_policy" "edafos-dynmo" {
#   arn = "arn:aws:iam::${local.accountNumber}:policy/s3_dynamodb_readwrite"
# }

# data "aws_iam_policy" "edafos-terraform" {
#   arn = "arn:aws:iam::${local.accountNumber}:role/TerraformExecutionRole"
# }

# data "aws_iam_policy" "s3_putobject" {
#   arn = "arn:aws:iam::${local.accountNumber}:role/s3_putobject"
# }

data "aws_iam_policy" "AssumeRole" {
  arn = "arn:aws:iam::${local.accountNumber}:policy/AssumeRole"
}
