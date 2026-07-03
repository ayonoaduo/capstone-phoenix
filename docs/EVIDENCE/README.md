# Evidence Checklist

Save screenshots or text logs here before submission.

- `01-nodes-ready.txt` - `kubectl get nodes -o wide`
- `02-pod-spread.txt` - `kubectl -n taskapp get pods -o wide`
- `03-tls.txt` - `curl -vI https://taskapp.<domain>`
- `04-postgres-pvc-survival.txt` - create task, delete Postgres pod, task still exists
- `05-zero-downtime-rollout.txt` - output from `scripts/zero-downtime-check.sh`
- `06-hpa.txt` - `kubectl -n taskapp get hpa -w` during load
- `07-argocd-synced.png` - Argo CD synced/healthy screenshot
- `08-failover-demo.txt` - node drain or worker shutdown notes
