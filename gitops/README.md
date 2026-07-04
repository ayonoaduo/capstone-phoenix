# GitOps

Argo CD is used after the cluster is built by Terraform and Ansible.

## Applications

- `apps/platform-secret-store.yaml` syncs `gitops/platform/external-secrets/`.
- `apps/taskapp.yaml` syncs `manifests/overlays/prod`.

Apply these once after Ansible installs Argo CD:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/platform-secret-store.yaml
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/taskapp.yaml
```

After that, app changes should go through git commits and Argo CD auto-sync.
