#!/bin/bash
set -euxo pipefail

zarf_version=0.24.2
ZARF_RELEASE_URL="https://github.com/defenseunicorns/zarf/releases/download"

# Save variable for pipeline runtime
echo $zarf_version > zarf_version.txt

# Zarf Init
sudo wget -P ~/.zarf-cache/ -q -nc ${ZARF_RELEASE_URL}/v${zarf_version}/zarf-init-amd64-v${zarf_version}.tar.zst
# wget -q -nc ${ZARF_RELEASE_URL}/v${zarf_version}/zarf-init-${ARCH}-v${zarf_version}.tar.zst

# Zarf CLI
sudo wget -P ~/bin/ -q -nc ${ZARF_RELEASE_URL}/v${zarf_version}/zarf_v${zarf_version}_Linux_amd64 -O zarf
# wget -q -nc ${ZARF_RELEASE_URL}/v${zarf_version}/zarf_v${zarf_version}_Linux_${ARCH}
sudo chmod 755 ~/bin/zarf

sudo ~/bin/zarf init --components k3s --confirm

# aws s3 cp /etc/rancher/k3s/k3s.yaml s3://tfstate-dd-kb/kubeconfigfiles/
