# Architecture

TaskApp runs on a three-node k3s cluster on AWS EC2: one control-plane node and two worker nodes. Terraform creates the VPC, subnet, security group, SSH key pair, and EC2 instances. Ansible hardens the hosts, installs k3s, joins the workers, fetches kubeconfig, and installs platform controllers. Argo CD owns the final application state from Git.

```text
DNS: taskapp.versv.net
  -> Traefik ingress on k3s
  -> taskapp-frontend Service
  -> nginx React frontend
  -> /api proxy
  -> taskapp-backend Service
  -> Flask/Gunicorn backend pods
  -> taskapp-postgres headless Service
  -> Postgres StatefulSet + PVC
```

## Request Flow

The user opens `https://taskapp.versv.net`. DNS points the hostname to the public cluster entry point. Traefik terminates ingress traffic using a Let's Encrypt certificate requested by cert-manager. The `taskapp` Ingress routes `/` to the frontend Service. The frontend container serves the React build with nginx and proxies `/api` to the backend Kubernetes Service. Backend pods connect to Postgres through the headless Service `taskapp-postgres`; the database stores data on a persistent volume created from the StatefulSet volume claim template.

## GitOps Flow

Argo CD watches this repository:

```text
gitops/apps/platform-secret-store.yaml -> gitops/platform/external-secrets
gitops/apps/taskapp.yaml               -> manifests/overlays/prod
```

External Secrets reads `taskapp/prod` from AWS Secrets Manager and creates the in-cluster `taskapp-secret`. The app uses Argo sync waves so first deploys happen in dependency order: namespace, config, external secret, Postgres, migration job, backend, frontend, HPA/PDB, ingress.

## What This Fixes

| Requirement | Design | Single-server risk fixed |
| --- | --- | --- |
| Multi-node Kubernetes | 1 k3s server, 2 workers | One host no longer carries all app workloads. |
| Persistent database | Postgres StatefulSet with PVC | Pod deletion does not erase task data. |
| Zero-downtime app layer | 2 frontend and 2 backend replicas | One pod can fail or roll while service stays available. |
| Safe rollout | RollingUpdate with `maxUnavailable: 0` | Deploys do not intentionally take all replicas down. |
| Health checks | startup, readiness, and liveness probes | Bad pods are kept out of service and restarted. |
| GitOps | Argo CD Application resources | Cluster state is reproducible from Git instead of manual kubectl drift. |
| Secrets hygiene | AWS Secrets Manager + External Secrets | Database/app secrets are not committed to Git. |
| Network control | Default-deny NetworkPolicies with explicit allows | Pods cannot freely talk to every service by default. |
| Resilience | PDBs, topology spread, resource requests/limits | Scheduler has enough information to place and protect pods. |
| Scaling evidence | HPA using CPU and memory | Backend can scale beyond static replicas under load. |

## Repo Structure

```text
app/                 TaskApp source, Dockerfiles, nginx config
infra/terraform/     AWS network, firewall, EC2, remote state config
infra/ansible/       k3s install, host hardening, platform bootstrap
manifests/           Kustomize base and production overlay
gitops/              Argo CD Application definitions
scripts/             helper scripts for secrets, inventory, load, rollout checks
docs/                architecture, runbook, cost, and evidence
```
