
variable "aws_region" {
  type        = string
  description = "AWS Region for deployment"
  default     = "us-east-2"
}

variable "shortname" {
    type = string
    description = "Shortname for the IAM profile"
    default = "edafos"
}

