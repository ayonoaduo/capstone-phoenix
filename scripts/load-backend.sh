#!/usr/bin/env bash
set -euo pipefail

# : "${TASKAPP_URL:?Set TASKAPP_URL, for example https://taskapp.example.com}"

for i in $(seq 1 12); do
  kubectl -n taskapp run backend-load-$i --image=busybox:1.36.1 --restart=Never -- \
    sh -c 'while true; do wget -q -O- http://taskapp-backend:5000/api/health >/dev/null; done'
done