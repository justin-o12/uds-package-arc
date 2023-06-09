#!/bin/bash
set -euxo pipefail

zarf_version=0.27.1
ZARF_RELEASE_URL="https://github.com/defenseunicorns/zarf/releases/download"

# Save variable for pipeline runtime
echo $zarf_version > zarf_version.txt

# Zarf Init
sudo wget -P ~/.zarf-cache/ -q -nc ${ZARF_RELEASE_URL}/v${zarf_version}/zarf-init-amd64-v${zarf_version}.tar.zst
# wget -q -nc ${ZARF_RELEASE_URL}/v${zarf_version}/zarf-init-${ARCH}-v${zarf_version}.tar.zst

# Zarf CLI
sudo wget -q -nc ${ZARF_RELEASE_URL}/v${zarf_version}/zarf_v${zarf_version}_Linux_amd64 -O /usr/bin/zarf
# wget -q -nc ${ZARF_RELEASE_URL}/v${zarf_version}/zarf_v${zarf_version}_Linux_${ARCH}
sudo chmod 755 /usr/bin/zarf
sync

# sudo /usr/bin/zarf init --components k3s --confirm
sudo zarf init --components k3s --confirm

aws s3 cp s3://tfstate-dd-kb-20230608200916573100000001/zarf-artifacts/zarf-config.toml /root/zarf-config.toml

aws s3 cp s3://tfstate-dd-kb-20230608200916573100000001/zarf-artifacts/zarf-package-actions-runner-controller-full-amd64.tar.zst \
    /root/zarf-package-actions-runner-controller-full-amd64.tar.zst

cd /root

zarf package deploy zarf-package-actions-runner-controller*.zst --confirm

# aws s3 cp /etc/rancher/k3s/k3s.yaml s3://tfstate-dd-kb/kubeconfigfiles/
