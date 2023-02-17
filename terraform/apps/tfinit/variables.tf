
variable "aws_region" {
  type        = string
  description = "AWS Region for deployment"
  default     = "us-east-2"
}

variable "bucket_name" {
  type        = string
  description = "Name of the Terraform Bucket"
  default     = "tfstate-dd-kb"
}

variable "shortname" {
  type        = string
  description = "Some simple short and profound name"
  default     = "edafos"
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags, always tag"
  default = {
    TEAM = "dashdays-kibbles-and-bits"
    Role = "DD KB Terraform Actions Init"
  }
}
