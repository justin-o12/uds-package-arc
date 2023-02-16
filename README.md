# Kibbles and Bits 

### Zarf package workflow:

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

### IaC Deploy

TODO
