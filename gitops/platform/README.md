# Platform GitOps Notes

Install Argo CD once with Ansible, then apply `gitops/apps/taskapp.yaml` to let Argo CD own TaskApp.

Platform controllers required before TaskApp sync:

- cert-manager
- metrics-server
- external-secrets
- kube-prometheus-stack or Prometheus/Grafana
- Cilium network policy enforcement

Create the `external-secrets-aws` Kubernetes Secret out-of-band, or replace this with IRSA on EKS. For this k3s-on-EC2 capstone, a narrowly scoped IAM access key for one AWS Secrets Manager secret is the simplest demonstrable path.
