# Argo CD Apps

Apply once after Argo CD is running:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/platform-secret-store.yaml
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/taskapp.yaml
```

Check:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n argocd get applications
```
