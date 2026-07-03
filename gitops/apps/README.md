# Argo CD Applications

After Ansible installs Argo CD, apply these once:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/platform-secret-store.yaml
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/taskapp.yaml
```

After that, Argo CD owns the live state. Changes should flow through git commits.
