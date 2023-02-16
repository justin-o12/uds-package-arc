data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


data "aws_ami" "amazon-linux-2" {
 most_recent = true
 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_instance" "foo" {
  ami           = data.aws_ami.amazon-linux-2.image_id
  instance_type = "t3.medium"
  associate_public_ip_address = true

    vpc_security_group_ids = [
    "sg-0a38d0e90d11c8ad4"
  ]

  tags = merge(
    var.tags,
    tomap({ "Name" = "I am a Jacks EC2 instance",
    })
  )
  user_data = <<EOF
#!/bin/bash
mkdir -p -m 700 /home/ec2-user/.ssh
echo -e "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFI3KW4H2dC6SYUn9YTGNAioSD0mSfNjoNXxoMF+2soh barry@dadwork.local" >> /home/ec2-user/.ssh/authorized_keys
EOF
}