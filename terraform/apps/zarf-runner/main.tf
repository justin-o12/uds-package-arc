locals {
  zarf_cloudinit_shell = file("cloudinit.sh")
}

data "aws_vpc" "example_vpc" {
  id = var.vpc_id
}

# Gets Subnet Id data
data "aws_subnet" "example_subnet" {
  id = var.subnet_id
}

resource "aws_security_group" "instance_security_group" {
  name        = "${var.shortname}_security_group"
  description = "${var.shortname} security groups"
  vpc_id      = data.aws_vpc.example_vpc.id
  tags = merge(
    var.tags,
    tomap({
      "Name" = "${var.shortname}_security_group",
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

data "cloudinit_config" "example_cloudinit" {
  gzip          = "false"
  base64_encode = "true"

  part {
    content_type = "text/x-shellscript"
    filename     = "cloudinit.sh"
    content      = local.zarf_cloudinit_shell
  }
}

resource "aws_instance" "foo" {
  ami                         = data.aws_ami.amazon-linux-2.image_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  iam_instance_profile        = var.instance_profile
  vpc_security_group_ids      = [aws_security_group.instance_security_group.id]
  subnet_id                   = data.aws_subnet.example_subnet.id

  key_name = var.instance_key

  user_data_base64 = data.cloudinit_config.example_cloudinit.rendered
  tags = merge(
    var.tags,
    tomap({
      "Name" = "${var.shortname}-ec2-runner",
    })
  )
}
