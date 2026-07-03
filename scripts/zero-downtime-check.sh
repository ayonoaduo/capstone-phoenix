#!/usr/bin/env bash
set -euo pipefail

: "${TASKAPP_URL:?Set TASKAPP_URL, for example https://taskapp.example.com}"

for i in $(seq 1 180); do
  code=$(curl -k -s -o /dev/null -w "%{http_code}" "$TASKAPP_URL/healthz" || true)
  printf "%s %s\n" "$(date -u +%FT%TZ)" "$code"
  sleep 1
done
