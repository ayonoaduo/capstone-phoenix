# Repository Structure

```text
app/
  backend/        Flask API, migrations, production Dockerfile
  frontend/       React app, nginx runtime, production Dockerfile
infra/
  terraform/      AWS VPC, firewall, EC2 nodes, remote state bootstrap
  ansible/        k3s installation, node hardening, platform bootstrap
manifests/
  base/           Kubernetes base manifests
  overlays/prod/  Production Kustomize overlay
gitops/
  apps/           Argo CD Application resources
  platform/       GitOps-managed platform integration manifests
docs/
  ARCHITECTURE.md Request flow, topology, and design rationale
  RUNBOOK.md      Provisioning, deployment, rollback, and recovery
  COST.md         Estimated monthly AWS cost
  EVIDENCE/       Submission evidence checklist
scripts/          Local helper scripts
```
