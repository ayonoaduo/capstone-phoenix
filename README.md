# Capstone Phoenix

TaskApp deployed to a three-node AWS k3s cluster with Terraform, Ansible, Argo CD, cert-manager TLS, autoscaling, network policies, and persistent Postgres.

## Quick Map

- `app/` - React frontend and Flask backend source plus Dockerfiles.
- `infra/terraform/` - AWS VPC, firewall, EC2 nodes, S3 remote state bootstrap.
- `infra/ansible/` - node hardening, k3s install, platform controllers.
- `manifests/` - Kustomize manifests for TaskApp.
- `gitops/` - Argo CD Applications.
- `docs/` - architecture, runbook, cost, and evidence checklist.
- `scripts/` - small helper commands used during provisioning and demos.

## Before Provisioning

Update local ignored files and deployment placeholders:

- `infra/terraform/bootstrap/terraform.tfvars`
- `infra/terraform/backend.hcl`
- `infra/terraform/terraform.tfvars`
- `gitops/platform/external-secrets/cluster-secret-store.yaml`
- `manifests/overlays/prod/kustomization.yaml`
- `manifests/base/ingress.yaml` or the prod overlay patches for domain/email

Do not commit real `.env`, `*.tfvars`, kubeconfig, Terraform state, node tokens, or secret values.

## Run

Use [docs/RUNBOOK.md](docs/RUNBOOK.md) as the command sequence from remote-state bootstrap through Argo CD sync.
