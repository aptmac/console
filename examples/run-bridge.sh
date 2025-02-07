#!/usr/bin/env bash

set -exuo pipefail

PROXY=$(cat <<EOF | jq -c .
{
  "services": [
    {
      "consoleAPIPath": "/api/proxy/plugin/cryostat-plugin/cryostat-plugin-proxy/",
      "endpoint": "http://localhost:8181"
    },
    {
      "consoleAPIPath": "/api/proxy/plugin/cryostat-plugin/cryostat-plugin-proxy/upstream/",
      "endpoint": "http://localhost:8181"
    },
    {
      "consoleAPIPath": "/api/v4/",
      "endpoint":"http://localhost:8181/api/v4/"
    }
  ]
}
EOF
)

./bin/bridge \
    --base-address=http://localhost:9000 \
    --ca-file=examples/ca.crt \
    --k8s-mode=off-cluster \
    --k8s-mode-off-cluster-endpoint="$(oc whoami --show-server)" \
    --k8s-mode-off-cluster-skip-verify-tls=true \
    --listen=http://127.0.0.1:9000 \
    --public-dir=./frontend/public/dist \
    --user-auth-oidc-client-id=console-oauth-client \
    --user-auth-oidc-client-secret-file=examples/console-client-secret \
    --user-auth-oidc-ca-file=examples/ca.crt \
    -plugins cryostat-plugin=http://localhost:9001/ \
    --plugin-proxy="$PROXY" \
    $@
