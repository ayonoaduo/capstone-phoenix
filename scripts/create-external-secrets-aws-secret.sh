#!/usr/bin/env bash
set -euo pipefail

: "${AWS_ACCESS_KEY_ID:?Set AWS_ACCESS_KEY_ID}"
: "${AWS_SECRET_ACCESS_KEY:?Set AWS_SECRET_ACCESS_KEY}"
: "${AWS_SESSION_TOKEN:?Set AWS_SESSION_TOKEN}"

KUBECONFIG_PATH="${KUBECONFIG_PATH:-infra/ansible/kubeconfig}"

kubectl --kubeconfig "$KUBECONFIG_PATH" create namespace external-secrets \
  --dry-run=client -o yaml | kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f -

kubectl --kubeconfig "$KUBECONFIG_PATH" -n external-secrets create secret generic external-secrets-aws \
  --from-literal=access-key-id="$AWS_ACCESS_KEY_ID" \
  --from-literal=secret-access-key="$AWS_SECRET_ACCESS_KEY" \
  --from-literal=session-token="$AWS_SESSION_TOKEN" \
  --dry-run=client -o yaml | kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f -
