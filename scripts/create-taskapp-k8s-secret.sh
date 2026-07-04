#!/usr/bin/env bash
set -euo pipefail

: "${DATABASE_USER:?Set DATABASE_USER}"
: "${DATABASE_PASSWORD:?Set DATABASE_PASSWORD}"
: "${SECRET_KEY:?Set SECRET_KEY}"
: "${TASKAPP_ADMIN_USERNAME:?Set TASKAPP_ADMIN_USERNAME}"
: "${TASKAPP_ADMIN_PASSWORD:?Set TASKAPP_ADMIN_PASSWORD}"
: "${TASKAPP_DEMO_USERNAME:?Set TASKAPP_DEMO_USERNAME}"
: "${TASKAPP_DEMO_PASSWORD:?Set TASKAPP_DEMO_PASSWORD}"

KUBECONFIG_PATH="${KUBECONFIG_PATH:-infra/ansible/kubeconfig}"

kubectl --kubeconfig "$KUBECONFIG_PATH" create namespace taskapp \
  --dry-run=client -o yaml | kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f -

kubectl --kubeconfig "$KUBECONFIG_PATH" -n taskapp create secret generic taskapp-secret \
  --from-literal=DATABASE_USER="$DATABASE_USER" \
  --from-literal=DATABASE_PASSWORD="$DATABASE_PASSWORD" \
  --from-literal=POSTGRES_USER="$DATABASE_USER" \
  --from-literal=POSTGRES_PASSWORD="$DATABASE_PASSWORD" \
  --from-literal=SECRET_KEY="$SECRET_KEY" \
  --from-literal=TASKAPP_ADMIN_USERNAME="$TASKAPP_ADMIN_USERNAME" \
  --from-literal=TASKAPP_ADMIN_PASSWORD="$TASKAPP_ADMIN_PASSWORD" \
  --from-literal=TASKAPP_DEMO_USERNAME="$TASKAPP_DEMO_USERNAME" \
  --from-literal=TASKAPP_DEMO_PASSWORD="$TASKAPP_DEMO_PASSWORD" \
  --dry-run=client -o yaml | kubectl --kubeconfig "$KUBECONFIG_PATH" apply -f -
