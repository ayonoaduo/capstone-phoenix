# Architecture

TaskApp runs on a three-node k3s cluster on AWS: one server node and two worker nodes. Terraform owns the VPC, subnet, security group, SSH key, and EC2 instances. Ansible hardens the nodes, installs k3s, joins workers, fetches kubeconfig, and installs the platform controllers.

## Request Flow

DNS points `taskapp.<domain>` to the public node address handling Traefik ingress. A browser request enters AWS security group ports `80/443`, reaches Traefik, terminates TLS through cert-manager's Let's Encrypt certificate, and routes to the frontend Service. The nginx frontend serves React assets and proxies `/api/*` to the backend Service. Backend pods talk to Postgres through the headless Postgres Service and a StatefulSet PVC.

## Single-Server Assumptions Fixed

- Startup database creation was removed from Flask replicas. Migrations now run once through the Argo CD PreSync Job.
- Frontend and backend run as Deployments with two replicas and topology spread constraints, so one node failure does not remove a whole tier.
- Postgres uses a StatefulSet and PVC so deleting the pod does not delete task data.
- Probes use `/healthz`, `/api/health`, and `pg_isready` so Kubernetes routes only to ready pods.
- Rolling updates use `maxUnavailable: 0` to keep capacity during deploys.
- NetworkPolicy defaults to deny and allows only required frontend, backend, Postgres, and DNS traffic.
- Secrets live in AWS Secrets Manager and are synced by External Secrets; secret values are not stored in git.
