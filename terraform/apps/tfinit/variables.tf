
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
