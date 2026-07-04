# Manifests

Kustomize layout for TaskApp.

- `base/` contains namespace, ConfigMap, ExternalSecret, Postgres StatefulSet, backend/frontend Deployments, migration Job, Ingress, HPA, PDB, and NetworkPolicy.
- `overlays/prod/` pins production image tags and patches environment-specific values.

Before syncing with Argo CD, confirm:

- image tags are pinned and not `latest`
- domain and Let's Encrypt email are real
- External Secrets points to the correct AWS region and secret store
- `kubectl kustomize manifests/overlays/prod` renders successfully
