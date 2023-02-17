variable "shortname" {
  type        = string
  description = "short name for the deployment"
  default     = "zarfbuilder"
}

variable "tags" {
  type = map(string)

  default = {
    TEAM = "dashdays-kibbles-and-bits"
    Role = "EC2 instance stuff"
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = "vpc-0a38d0e90d11c8ad4"
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 instance type"
  default     = "t3.medium"
}

variable "instance_key" {
  type        = string
  description = "AWS Keypair ID, optional if needed"
  default     = null
}

variable "instance_profile" {
  type        = string
  description = "AWS IAM Instance Profile"
  default     = "edafos-Profile"
}
