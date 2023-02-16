[[_TOC_]]

# Terraform Instance 

Simple single AWS instance example with some of the basics features that needs to be added for deploying a single instance of RHEL-8 in AWS us-east-1. This is merely an example of how to create an instance and create a basice `cloud-init` script for after deployments. 

# Use

In the `rhelcheck.tf` file, go to the `locals` section and update all the variables as needed. Feel free to pull this information from the AWS web console if the values are unknown. The variables should match what is required from a user launching an instance through the GUI. When the variables are updated, save the `rhelcheck.tf` file in. 

Then, assuming the variables are correct, deploy with: 
1. `terraform init` which will only need to be run the first time in that folder.
1. `terraform apply --auto-approve` which will attempt to deploy the instance.

# Cleanup

After the instance is done, the instance maybe deleted with:
```bash
terraform destroy --auto-approve
```

# Use as module

To use as a module, create a terraform file in a folder similar to the following. 

```terraform
module "jumper" {
  source               = "git::git@gitlab.net:please-fork-me/example/terraform-instance.git"
  aws_region           = "us-east-1"
  amiID                = "ami-12312348984"
  instance_type        = "t2.micro"
  iam_instance_profile = "my-instance"
  subnet_id            = "subnet-0cxxxxxxxxxxxxxxx"
  vpc_id               = "vpc-053xxxxxxxxxxxxxx"
  ssh_key              = "xxx-keypair"
  root_vol_size        = "30"
  ec2_tags = tomap({
    COST_CENTER = "55555",
    APP_ID      = "4444",
    Name        = "exampleInstance",
    Role        = "Example-Instance"
  })
}

output "connect_ip" {
  value = module.jumper.instance_ip_addr
}
```

# Pre-Requisites

Install Terraform. Have all the vpc, key information, subnets, etc... filled out in AWS already. 

# Generated Module Variables

## Module Data
| Data Name |
| :--- | 
| aws_ssm_parameter |
| aws_subnet |
| cloudinit_config |
| aws_vpc |

## Module Resources
| Resource Name |
| :--- | 
| aws_instance |
| aws_network_interface |
| aws_security_group |
| aws_security_group_rule |

## Module Variables
| Variable Name | Variable Description | Type | Default |
| :--- | :--- | :---: | ---: |
| aws_region | AWS Region | ${string} | us-east-1 |
| amiID | ami ID  | ${string} | /nimbus/gold/linux/rhel-8 |
| instance_type | Instance Size | ${string} | t2.micro |
| iam_instance_profile | IAM Instance IAM Role | ${string} | None |
| subnet_id | EC2 Subnet | ${string} | None |
| vpc_id | VPC ID | ${string} | None |
| root_vol_size | EC2 Root volume size | ${number} | 100 |
| ssh_key | Ec2 Key Pair .Pem file | ${string} | None |
| ec2_tags | Tags like costcenter, name, role, AppId | ${map(string)} | None |
| cloudinit_path | Path for cloudinit script, leave blank for default | ${string} | None |

## Module Output
| Output Name | Description | Value |
| :--- | :---: | ---: | 
| instance_ip_addr | N/A | ${aws_instance.example_ec2_instance.private_ip} |

