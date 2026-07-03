# Capstone Phoenix: TaskApp on Real Kubernetes

This repository deploys TaskApp to a three-node k3s cluster on AWS with Terraform, Ansible, Kubernetes manifests, Argo CD GitOps, HTTPS, autoscaling, network policy, and operational evidence.

## Layout

- `app/backend` - Flask API, migrations, production Dockerfile.
- `app/frontend` - React frontend, nginx runtime, production Dockerfile.
- `infra/terraform` - AWS network, security group, EC2 nodes, remote state bootstrap.
- `infra/ansible` - node hardening, k3s install, kubeconfig fetch, platform bootstrap.
- `manifests` - Kustomize app manifests for TaskApp.
- `gitops` - Argo CD Application manifests.
- `docs` - architecture, runbook, cost, and evidence checklist.

## Required local values

Before deployment, replace every `CHANGE_ME` placeholder with your real values:

- GitHub username/repo URL.
- AWS region/profile.
- Domain name and Let's Encrypt email.
- GHCR image tags.
- AWS Secrets Manager secret `taskapp/prod`.

No real secrets, kubeconfigs, Terraform state, or `.env` files should be committed.
