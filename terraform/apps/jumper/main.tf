
# Only fill out variables here
locals {
  prefix                   = "${var.aws_region}_${lookup(var.ec2_tags, "Name", "tstInstance")}_"
  aws_region               = var.aws_region # AWS Region
  instance_type            = var.instance_type
  iam_instance_profile     = var.iam_instance_profile
  root_volume_size         = var.root_vol_size
  ssh_key_name             = var.ssh_key
  my_subnet_id             = var.subnet_id
  vpc_id                   = var.vpc_id
  my_tags                  = var.ec2_tags
  example_cloudinit_script = var.cloudinit_path == null ? file("${path.module}/cloudinit.sh") : file("${var.cloudinit_path}")
}

# Sets AMI instance
data "aws_ssm_parameter" "gold_ami_id" {
  name = local.amiNimbusId
}

# Gets Subnet Id data
data "aws_subnet" "example_subnet" {
  id = local.my_subnet_id
}

# Network interface for instance
resource "aws_network_interface" "example_network" {
  subnet_id       = data.aws_subnet.example_subnet.id
  security_groups = [aws_security_group.instance_security_group.id]
  description     = "${local.prefix} network interface"
}

# Needed to render and send cloud init script
data "cloudinit_config" "example_cloudinit" {
  gzip          = "false"
  base64_encode = "true"

  part {
    content_type = "text/x-shellscript"
    filename     = "cloudinit.sh"
    content      = local.example_cloudinit_script
  }
}

data "aws_vpc" "example_vpc" {
  id = local.vpc_id
}

resource "aws_security_group" "instance_security_group" {
  name        = "${local.prefix}security_group"
  description = lookup(var.ec2_tags, "Name", "tstInstance")
  vpc_id      = data.aws_vpc.example_vpc.id
  tags = merge(
    var.ec2_tags,
    tomap({ "Name" = "${local.prefix}security_group",
    })
  )
}

resource "aws_security_group_rule" "self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.instance_security_group.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance_security_group.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instance_security_group.id
}

# Creates the instance
resource "aws_instance" "example_ec2_instance" {
  ami                                  = var.amiID
  instance_type                        = local.instance_type
  key_name                             = local.ssh_key_name
  iam_instance_profile                 = local.iam_instance_profile
  instance_initiated_shutdown_behavior = "stop"
  tags                                 = local.my_tags
  user_data_base64                     = data.cloudinit_config.example_cloudinit.rendered

  root_block_device {
    volume_size = local.root_volume_size
    encrypted   = true
  }

  network_interface {
    network_interface_id = aws_network_interface.example_network.id
    device_index         = 0
  }
}

output "instance_ip_addr" {
  value = aws_instance.example_ec2_instance.private_ip
}
