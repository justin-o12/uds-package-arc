# VARIABLES

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "Instance Size"
  default     = "t2.micro"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM Instance IAM Role"
}

variable "subnet_id" {
  type        = string
  description = "EC2 Subnet"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "root_vol_size" {
  type        = number
  description = "EC2 Root volume size"
  default     = 100
}

variable "ssh_key" {
  type        = string
  description = "Ec2 Key Pair .Pem file"
}

variable "ec2_tags" {
  type        = map(string)
  description = "Tags like costcenter, name, role, AppId"
}

variable "cloudinit_path" {
  type        = string
  description = "Path for cloudinit script, leave blank for default"
  default     = null
}
