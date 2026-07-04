# Evidence

Capture these before submission:

- `kubectl get nodes -o wide`
- `kubectl -n taskapp get pods -o wide`
- valid TLS check: `curl -vI https://taskapp.<domain>`
- Postgres data still present after deleting the Postgres pod
- zero-downtime rollout output from `scripts/zero-downtime-check.sh`
- HPA scaling output while running `scripts/load-backend.sh`
- Argo CD app synced and healthy
- worker drain or shutdown demo notes
