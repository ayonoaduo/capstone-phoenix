#!/usr/bin/env bash
set -euo pipefail

terraform -chdir=infra/terraform output -raw ansible_inventory > infra/ansible/inventory.ini
echo "Wrote infra/ansible/inventory.ini"
