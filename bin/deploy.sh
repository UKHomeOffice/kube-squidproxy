#!/bin/bash

set -o errexit
set -o nounset

# Currently using the same version tag for all phub services
export VERSION=v0.0.2

export AWS_DSP_TOOLSET_VERSION=v1.2.6

export DRONE_DEPLOY_TO=${DRONE_DEPLOY_TO:?'[error] Please specify which instance to deploy to'}

export TRIGGER_SLEEP_SECONDS=5m

case ${DRONE_DEPLOY_TO} in
  'acp-testing')
    export KUBE_NAMESPACE=squidproxy
    export KUBE_SERVER=${KUBE_SERVER_ACP_TESTING}
    export KUBE_TOKEN=${KUBE_TOKEN_ACP_TESTING}
  ;;
  *)
    echo '[error] unknown deploy to target specified (in \$DRONE_DEPLOY_TO)'
    exit 1
esac

echo "--- Kube API URL: ${KUBE_SERVER}"
echo "--- Kube namespace: ${KUBE_NAMESPACE}"

kd --insecure-skip-tls-verify \
  --timeout 10m0s \
  -f kube/squidproxy-deployment.yaml \
  -f kube/squidproxy-service.yaml \
  -f kube/squidproxy-ingress.yaml
