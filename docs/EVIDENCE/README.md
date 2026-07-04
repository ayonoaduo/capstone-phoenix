# Evidence Checklist

Save screenshots or terminal logs for each item before submission.

## Required Proof

Nodes:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig get nodes -o wide
```

Pods spread across nodes:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -o wide
```

Argo CD synced and healthy:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n argocd get applications
kubectl --kubeconfig infra/ansible/kubeconfig -n argocd describe application taskapp
```

TLS certificate:

```bash
curl -vI https://taskapp.versv.net
```

Postgres persistence:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp delete pod taskapp-postgres-0
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -w
```

Zero-downtime rollout:

```bash
./scripts/zero-downtime-check.sh https://taskapp.versv.net
```

HPA scaling:

```bash
./scripts/load-backend.sh https://taskapp.versv.net
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get hpa -w
```

Worker failover:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig drain <worker-node> --ignore-daemonsets --delete-emptydir-data
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -o wide
kubectl --kubeconfig infra/ansible/kubeconfig uncordon <worker-node>
```

## Suggested Files

```text
docs/EVIDENCE/nodes.txt
docs/EVIDENCE/pods-wide.txt
docs/EVIDENCE/argocd.txt
docs/EVIDENCE/tls-curl.txt
docs/EVIDENCE/postgres-persistence.txt
docs/EVIDENCE/zero-downtime.txt
docs/EVIDENCE/hpa.txt
docs/EVIDENCE/worker-drain.txt
```
