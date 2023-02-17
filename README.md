# Kibbles and Bits 

### Zarf package workflow

```bash
zarf package create

cat >zarf-config.toml <<EOF
[package.deploy.set]
# https://github.com/actions/actions-runner-controller/blob/master/docs/authenticating-to-the-github-api.md#deploying-using-github-app-authentication
[package.deploy.set]
github_app_id = "123"
github_app_installation_id = "456"
github_app_private_key = """-----BEGIN RSA PRIVATE KEY-----\n
...\n
...\n
...\n
-----END RSA PRIVATE KEY-----"""

# won't work now because we removed this zarf variable, but the helm chart supports a PAT too:
# https://github.com/settings/tokens/new
# github_token = "ghp_REDACTEDREDACTEDREDACTEDREDACTEDREDA"
EOF

zarf init

zarf package deploy zarf-package-actions-runner-controller-full-amd64.tar.zst
```


Useful debug commands:
```bash
# actions controller logs, includes 401 error if PAT is bad
# should show no errors
kubectl logs -n actions-runner-system deployment/arc-actions-runner-controller -f

# Inspect the runners:
kubectl get RunnerDeployment,Runner,Pods -n actions-runner

# If the Secret is updated, the actions-runner-controller is not automatically restarted
# You need to restart it manually
# This is arguably a bug in the actions-runner-controller helm chart
kubectl rollout restart deployment -n actions-runner-system arc-actions-runner-controller

# Runner should appear as "idle" at:
# https://github.com/defenseunicorns/kibbles-AND-bits/settings/actions/runners


#debug ephemeral runner Pods:

kubectl get pods -n actions-runner  -w -o 'custom-columns=NAME:.metadata.name,IMAGES:.spec.containers[*].image,VOLUMES:.spec.volumes[*].name,PHASE:.status.phase'

kubectl get pods -n actions-runner -o yaml -w
```

## IaC Deploy

IaC for deployments has 2 steps: 
1. [Deploy Terraform Bucket and DynamoDB](#markdown-header-terraform-state-bucket-&-dynamodb)  for lock files.
  1. *Optional* Test with a test bucket deployment. 
1. Deploy a single node [Zarf instance](#markdown-header-iac-zarf-instance)

This deployment will allow AWS to manage the statefile and lock for local deployments and with a team and for setting up for IaC through GitHub Actions or other CD automation.


### Terraform State Bucket & DynamoDB

First deployment needs to set up bucket for the Terrraform state files for team collaborations and a DynamoDB table for locking state. The goal is to boot strap a deployment cluster. The Terraform state bucket and DynamoDB lock table will then beable to be used to any IaC deployment through CI/CD systems on the Zarf Cluster. This simplified setup will be used to support all IaC operations local to the account or run from the account.

**Steps To Deploy:** 
* Ensure AWS CLI is working and has a connection to the account. 
* Change directory in to the folder in this repo `terraform/apps/tfinit`
* `terraform init`
* `terraform apply -auto-approve`
* Bask in your own success.

**If already deployed:**
If already deployed and the stateful is lost. 
* Ensure AWS CLI is working and has a connection to the account. 
* Change directory in to the folder in this repo `terraform/apps/tfinit`
* `terraform init`
* `bash importer.sh` # Will generate the state file from existing AWS state
* `terraform apply -auto-approve`
* Bask in your own success.

### IaC Zarf Instance

Deploys an EC2 instance. Automatically (via Cloud-Init shell script) will:
* Install Zarf CLI and Zarf init packages from GitHub
* Install k3s via `sudo zarf init --components k3s --confirm`

**Steps to Deploy:**
* Ensure [Deploy Terraform Bucket and DynamoDB](#markdown-header-terraform-state-bucket-&-dynamodb) has been run already. 
* Change directory in to the folder in this repo `terraform/apps/zarf-runner`.
* `terraform init`
* `terraform apply -auto-approve`
* SSH into the instance, to confirm the cloud init script is done running:
  * First run `sudo cloud-init status`
  * Watch with `sudo tail -f /var/log/cloud-init-output.txt` and wait for a completed message.
* **TODO:* Handle with secrets or extend automation to include efforts in [Zarf package workflow](markdown-header-zarf-package-workflow).

**Steps to Destroy:**
* In the same folder, run `terraform destroy -auto-approve`. State file is managed by the S3 and DynamoDB.

### IaC Testing/Bonus

There are two projects used to verify that the TF init works and can be used an example of using the provisioned Terraforom S3 bucket for state files and using DynamoDB. First is a simple example in `examples/makebucket`. Another is a basic EC2 instance deployed via Terraform and the AWS managed state in `modules/ec2/`. 

**Steps for makebucket:**
* Ensure AWS CLI is working and has a connection to the account. 
* Change directory in to the folder in this repo `examples/makebucket`
* `terraform init`
* `terraform apply -auto-approve`
* To destroy (if empty), `terraform destroy -auto-approve`

**EC2 Module:**
* View the Read Me file in `terraform/modules/ec2/README.md`
* Copy the sample Terraform code from the code block in the Read Me file anywhere locally EXCEPT in the same folder.
* Set the line for `source = "./ec2"` path explicitely or relatively from saved Terraform file to the `ec2` folder.
* Fill in module variables as needed/desired.
* Ensure AWS CLI is working and has a connection to the account. 
* Change directory in to the folder in this repo `examples/makebucket`
* `terraform init`
* `terraform apply -auto-approve`
* To destroy (if empty), `terraform destroy -auto-approve`
 
