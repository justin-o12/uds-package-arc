# Kibbles and Bits 

### Installation

The following instructions describe how to create and install a GitHub App onto a GitHub _org_. A similar process can be used to install the GitHub App onto a single repository only. Note, that you can also install the GitHub App onto an org and limit it's "Repository access" to "Only select repositories".

See the upstream actions-runner-controller documentation for full installation steps:
https://github.com/actions/actions-runner-controller/blob/master/docs/authenticating-to-the-github-api.md#deploying-using-github-app-authentication

1. **Create an GitHub App on your GitHub org**
   * Contrary to the actions-runner-controller documentation, "Administration (read / write)" permissions are not required.
   * You may use the following URL to create the application on an org. Replace `:org` in the following URL with the name of your org:
     ```
     https://github.com/organizations/:org/settings/apps/new?url=http://github.com/actions/actions-runner-controller&webhook_active=false&public=false&organization_self_hosted_runners=write&actions=read&checks=read
     ```
2. **Record the "App ID" in the App's settings**
    * This is the `GITHUB_APP_ID` Zarf variable
3. **In the App's settings, generate and download a private key file by clicking "Generate a private key"**
    * This is `GITHUB_APP_PRIVATE_KEY` Zarf variable
    * Due to a Zarf variable issue, you will need to include literal `\n` to create newlines in the variable
4. **In the App's settings, click "Install App" on the left, and install the application on the org**
    * Record the installation ID (it is at the end of URL), this is the `GITHUB_APP_INSTALLATION_ID` Zarf variable
    * If desired, you may limit the installation's "Repository access" to "Only select repositories"
5. **The URL of the org the application was installed on is `GITHUB_CONFIG_URL`**
6. **Create a `zarf-config.toml` with the variables configured as desired:**
   ```toml
   [package.deploy.set]

   # The URL of the GitHub org that the GitHub App is installed on
   github_config_url = "https://github.com/octocat"
   
   # The id of the GitHub App
   github_app_id = "123"
   
   # The id of the installation of the GitHub App on the org
   # This id can be found in the URL of the installation's settings
   github_app_installation_id = "456"
   
   # The private key of the GitHub App
   github_app_private_key = """-----BEGIN RSA PRIVATE KEY-----\n
   ...\n
   ...\n
   ...\n
   -----END RSA PRIVATE KEY-----"""
   
   # Optional. The name of the runner group to register the scale set in
   # You must first create the runner group in the GitHub UI manually before setting it here
   #github_runner_group="default"
   
   # The name of the runner scale set
   # This value is effectively a GitHub runs-on label for the runners. Note the runners will not have an "on-prem" label
   github_runner_scaleset_name = "arc"
   
   # The storage class name used for the Kubernetes ephemeral volume (temporary PVC/PV) used for the working directory of workflow execution.
   # If using k3s/k3d you can use the `local-path` storage class.
   github_runner_storage_class = "local-path"
   
   # Optional. The size of the ephemeral volume
   # Note, local-path does not enforce storage limits.
   #github_runner_storage_size = 1Gi
   
   # Optional. The maximum number of runners to run concurrently.
   #github_max_runners = 5
   
   # Optional. The minimum number of runners to scale down to.
   # By default it will scale to zero.
   #github_min_runners = 0
   ```
7. Install the actions-runner-controler Zarf package
   ```bash
   zarf package deploy oci://ghcr.io/defenseunicorns/packages/actions-runner-controller:0.0.1-amd64
   ```

Useful debug commands:
```bash
# TODO: verify with scale sets:


# actions controller logs, includes 401 error if PAT is bad
# should show no errors
kubectl logs -n arc-systems deployment/arc-actions-runner-controller -f

# Inspect the runners:
kubectl get RunnerDeployment,Runner,Pods -n arc-runners

# If the Secret is updated, the actions-runner-controller is not automatically restarted
# You need to restart it manually
# This is arguably a bug in the actions-runner-controller helm chart
kubectl rollout restart deployment -n arc-systems

# Runner should appear as "idle" at:
# https://github.com/defenseunicorns/kibbles-AND-bits/settings/actions/runners


#debug ephemeral runner Pods:

kubectl get pods -n arc-runners  -w -o 'custom-columns=NAME:.metadata.name,IMAGES:.spec.containers[*].image,VOLUMES:.spec.volumes[*].name,PHASE:.status.phase'

kubectl get pods -n arc-runners -o yaml -w
```

