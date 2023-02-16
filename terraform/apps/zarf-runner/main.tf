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

data "aws_vpc" "example_vpc" {
  id = var.vpc_id
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

resource "aws_instance" "foo" {
  ami                         = data.aws_ami.amazon-linux-2.image_id
  instance_type               = var.instance_type
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.instance_security_group.id]

  tags = var.tags
  # tags = merge(
  #   var.tags,
  #   tomap({ "Name" = "I am a Jacks EC2 instance",
  #   })
  # )
  user_data = <<EOF
#!/bin/bash
mkdir -p -m 700 /home/ec2-user/.ssh
echo -e "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFI3KW4H2dC6SYUn9YTGNAioSD0mSfNjoNXxoMF+2soh barry@dadwork.local" >> /home/ec2-user/.ssh/authorized_keys
EOF
}
