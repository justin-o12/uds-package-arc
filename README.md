# Kibbles and Bits 

## Overview



As an organization, we are advocating for the use of Zarf, IaC and Big Bang to manage software factories, but we are not using that tech stack in our own pipelines. By dogfooding the runners for GitHub, we should improve the feedback loop for issues and concerns with how runners are being used and configured, to make a better product for all our customers now, and when we deploy runners as a service in our Delivery Platform - Not (a) Software Factory.  



In order for Zarf to leverage these pipelines, more capability is needed than just being able to test terraform. Understanding how to do testing on VMs within our stack will be required to satisfy some of the existing test frameworks in Zarf. And can be out of scope for the initial  POC, but will have to be tackled at some point, potentially with KubeVirt, or some other solution that we stand behind.

## Outcomes

Create a Zarf package that can deploy a stack, including IAC, with Kubernetes-hosted GitHub runners in a way we would advocate our customers do. Then, configure pipelines for a project repo in GitHub  (e.g. https://github.com/defenseunicorns/pepr) to use the runners deployed by the GitHub Actions Zarf package. We will probably need to create a BigBang package for GitHub Runners.



While implementing the runners, identify security and operational best practices for our users (not all implementation will be completed during Dash Days, but identify potential issues for future work). 

Potential security considerations. Enable users of the pipelines to access cloud resources (e.g. AWS) with ephemeral GitHub OIDC pipeline credentials (About security hardening with OpenID Connect - GitHub Docs). Consider options for connecting a pipeline to in-cluster services (e.g. a container scanning tool), ideally with ephemeral credentials. Identify the security posture of the default deployment of GitHub Actions in Kubernetes, and identify options for future hardening. Figure out how to select a CRI (potentially use a more secure one in the future).

Make operational recommendations for users. Use one runner per project, or per security boundary, or when dedicated resources are needed? Are separate clusters needed, or can multiple runners share one? Should separate AWS accounts be used for security isolation, or separate billing?

## Growth if Successful

The proof of concept would showcase to Vivsoft and FDIC that we can deploy and use BigBang to manage GitHub Runners for their workloads, which should be the input we need to get our stack into that environment.

## Customer Demand

FDIC is looking to run self-hosted GitHub runners, and every other customer we have builds software on a stack that we’re advocating for, except us.





Tentative plan

1. Deploy a cluster with IAC
  * https://github.com/defenseunicorns/iac/tree/main/modules/eks as a starting point?
  * Or write our own minimal Terraform for just EKS?
2. Select a runner implementation to use, likely one of: (or test both!)
  * https://github.com/actions/actions-runner-controller (This one looks more official)
  * https://github.com/evryfs/github-actions-runner-operator
3. Add the runner to a Zarf package
  * Deploy the runner controller and create runners associated to projects/org
4. Test runner with a project’s pipeline.
  * Make sure image: works (docker? k8s? however this thing works) https://github.com/actions/actions-runner-controller/blob/master/docs/deploying-alternative-runners.md

Where possible, work tasks in parallel (e.g. deploy runners using k3d while IAC is being worked on?). 



Resources

(possible) GH runners on K8s https://github.com/actions/actions-runner-controller
