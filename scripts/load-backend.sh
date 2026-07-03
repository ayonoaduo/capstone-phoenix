#!/usr/bin/env bash
set -euo pipefail

: "${TASKAPP_URL:?Set TASKAPP_URL, for example https://taskapp.example.com}"

kubectl run backend-load --rm -i --tty --restart=Never --image=busybox:1.36.1 -- \
  sh -c "while true; do wget -q -O- ${TASKAPP_URL}/api/health >/dev/null; done"
