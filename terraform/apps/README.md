# Applications

Stand alone applications/zarf installations either needed as a prequisite or as small necessary coherent deployment.

## Jumper

Original Jumpbox. Made to be a box simple box to deploy as a start to a bastion for hosting a runner.

## tfinit

**NOTE:** Meant to be run first and run once

The goal of tfinit is create an S3 bucket and DynamoDB table for managing Terraform state files. This ensures AWS manages the state files which enables cooperative iterations when iterating the Terraform.

## zarf-runner

A sample runner that relies upon the [tfinit](#tfinit) for managing the Terraform state. This Zarf-Runner will create a single ec2 instance, install [Zarf](https://zarf.dev/), install k3s from Zarf, and initialize the cluster, and with the Kibbles and Bits zarf package (and zarf-config file) deploy a self hosted kubernetes GitHub Actions runner.

