#!/usr/bin/env bash
set -euo pipefail

: "${AWS_REGION:?Set AWS_REGION}"
: "${DATABASE_USER:?Set DATABASE_USER}"
: "${DATABASE_PASSWORD:?Set DATABASE_PASSWORD}"
: "${SECRET_KEY:?Set SECRET_KEY}"
: "${TASKAPP_ADMIN_USERNAME:?Set TASKAPP_ADMIN_USERNAME}"
: "${TASKAPP_ADMIN_PASSWORD:?Set TASKAPP_ADMIN_PASSWORD}"
: "${TASKAPP_DEMO_USERNAME:?Set TASKAPP_DEMO_USERNAME}"
: "${TASKAPP_DEMO_PASSWORD:?Set TASKAPP_DEMO_PASSWORD}"

payload=$(jq -n \
  --arg database_user "$DATABASE_USER" \
  --arg database_password "$DATABASE_PASSWORD" \
  --arg secret_key "$SECRET_KEY" \
  --arg admin_username "$TASKAPP_ADMIN_USERNAME" \
  --arg admin_password "$TASKAPP_ADMIN_PASSWORD" \
  --arg demo_username "$TASKAPP_DEMO_USERNAME" \
  --arg demo_password "$TASKAPP_DEMO_PASSWORD" \
  '{database_user: $database_user, database_password: $database_password, secret_key: $secret_key, admin_username: $admin_username, admin_password: $admin_password, demo_username: $demo_username, demo_password: $demo_password}')

if aws secretsmanager describe-secret --region "$AWS_REGION" --secret-id taskapp/prod >/dev/null 2>&1; then
  aws secretsmanager put-secret-value --region "$AWS_REGION" --secret-id taskapp/prod --secret-string "$payload"
else
  aws secretsmanager create-secret --region "$AWS_REGION" --name taskapp/prod --secret-string "$payload"
fi
