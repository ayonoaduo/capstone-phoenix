# Structure

```text
app/                 TaskApp source and Dockerfiles
infra/terraform/     AWS remote state, network, firewall, EC2 nodes
infra/ansible/       host hardening, k3s install, platform bootstrap
manifests/           Kustomize app manifests
gitops/              Argo CD Application resources
docs/                architecture, runbook, cost, evidence checklist
scripts/             helper commands for inventory, secrets, and demos
```
