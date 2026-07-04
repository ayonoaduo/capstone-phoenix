# Architecture

TaskApp runs on AWS EC2 using one k3s server and two k3s workers. Terraform creates the network, firewall, key pair, and nodes. Ansible hardens the hosts, installs k3s, joins workers, fetches kubeconfig, and installs platform controllers.

## Request Flow

`taskapp.<domain>` resolves to the cluster ingress. Traefik receives HTTPS traffic, cert-manager provides the Let's Encrypt certificate, and the Ingress routes to the frontend Service. The nginx frontend serves React and proxies `/api` to the backend Service. Backend pods connect to Postgres through a headless Service and StatefulSet PVC.

## Key Design Choices

- Same-origin `/api` avoids browser CORS and keeps one TLS hostname.
- Migrations run as an Argo CD PreSync Job so backend replicas do not race.
- Frontend and backend run with two replicas and topology spread constraints.
- Postgres uses StatefulSet plus PVC so task data survives pod replacement.
- NetworkPolicy defaults to deny and only opens required app paths.
- External Secrets reads AWS Secrets Manager so secret values stay out of git.
- HPA, PDBs, probes, resource limits, and security contexts cover the advanced requirements.
