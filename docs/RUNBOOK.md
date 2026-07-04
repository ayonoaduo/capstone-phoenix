# Runbook

Commands assume the repo root is the current directory.

## Provision From Zero

1. Bootstrap remote Terraform state.

```bash
cp infra/terraform/bootstrap/terraform.tfvars.example infra/terraform/bootstrap/terraform.tfvars
terraform -chdir=infra/terraform/bootstrap init
terraform -chdir=infra/terraform/bootstrap apply -var-file=terraform.tfvars
```

2. Configure and create the AWS nodes.

```bash
cp infra/terraform/backend.example.hcl infra/terraform/backend.hcl
cp infra/terraform/terraform.tfvars.example infra/terraform/terraform.tfvars
terraform -chdir=infra/terraform init -backend-config=backend.hcl
terraform -chdir=infra/terraform apply -var-file=terraform.tfvars
./scripts/render-inventory.sh
```

3. Install k3s and platform controllers.

```bash
ansible-galaxy collection install -r infra/ansible/requirements.yml
ansible-playbook -i infra/ansible/inventory.ini infra/ansible/site.yml
ansible-playbook -i infra/ansible/inventory.ini infra/ansible/site.yml
```

4. Create runtime secrets.

```bash
eval "$(aws configure export-credentials --profile backend --format env)"
bash scripts/create-external-secrets-aws-secret.sh

AWS_REGION=eu-north-1 \
DATABASE_USER=taskapp \
DATABASE_PASSWORD='replace-me' \
SECRET_KEY='replace-me' \
TASKAPP_ADMIN_USERNAME=admin \
TASKAPP_ADMIN_PASSWORD='replace-me' \
TASKAPP_DEMO_USERNAME=oni \
TASKAPP_DEMO_PASSWORD='replace-me' \
./scripts/create-taskapp-secret.sh
```

5. Point DNS.

Create or update `taskapp.versv.net` to point to the public node IP used by Traefik.

```bash
terraform -chdir=infra/terraform output control_plane_public_ip
```

6. Start GitOps.

```bash
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/platform-secret-store.yaml
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/taskapp.yaml
```

## Verify

```bash
kubectl --kubeconfig infra/ansible/kubeconfig get nodes -o wide
kubectl --kubeconfig infra/ansible/kubeconfig -n argocd get applications
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -o wide
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get ingress,externalsecret,hpa,pdb
curl -vI https://taskapp.versv.net
```

## Scale

Manual scale test:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp scale deploy/taskapp-backend --replicas=4
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -o wide
```

Return to GitOps-owned state:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n argocd annotate application taskapp argocd.argoproj.io/refresh=hard --overwrite
```

HPA load test:

```bash
./scripts/load-backend.sh https://taskapp.versv.net
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get hpa -w
```

## Roll Back

Revert the image tag change in Git and push:

```bash
git revert <bad-image-tag-commit>
git push origin main
```

Watch Argo roll the app back:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n argocd get application taskapp -w
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp rollout status deploy/taskapp-backend
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp rollout status deploy/taskapp-frontend
```

## Recovery

Dead worker:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig drain <worker-node> --ignore-daemonsets --delete-emptydir-data
kubectl --kubeconfig infra/ansible/kubeconfig get pods -n taskapp -o wide
kubectl --kubeconfig infra/ansible/kubeconfig uncordon <worker-node>
```

If the instance is gone, replace it with Terraform, render inventory, and rerun Ansible.

Dead backend pod:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp delete pod -l app.kubernetes.io/name=taskapp-backend
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp rollout status deploy/taskapp-backend
```

Bad migration:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp logs job/taskapp-migrate
git revert <migration-or-image-commit>
git push origin main
kubectl --kubeconfig infra/ansible/kubeconfig -n argocd delete application taskapp --ignore-not-found
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/taskapp.yaml
```

Postgres pod replacement:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp delete pod taskapp-postgres-0
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp rollout status statefulset/taskapp-postgres
```

## Demo Script

Time target: 10 minutes.

1. Show architecture for 90 seconds: Terraform creates 3 EC2 nodes, Ansible installs k3s/platform, Argo deploys TaskApp, request path is DNS -> Traefik -> frontend -> backend -> Postgres.
2. Show cluster health:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig get nodes -o wide
kubectl --kubeconfig infra/ansible/kubeconfig -n argocd get applications
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -o wide
```

3. Show the app and TLS:

```bash
curl -vI https://taskapp.versv.net
```

4. Show persistence: create a task in the UI, delete the Postgres pod, wait for it to return, refresh the UI, and show the task is still present.

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp delete pod taskapp-postgres-0
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -w
```

5. Show live failover: start the zero-downtime checker, then drain one worker.

```bash
./scripts/zero-downtime-check.sh https://taskapp.versv.net
kubectl --kubeconfig infra/ansible/kubeconfig drain <worker-node> --ignore-daemonsets --delete-emptydir-data
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -o wide
kubectl --kubeconfig infra/ansible/kubeconfig uncordon <worker-node>
```

6. Show HPA:

```bash
./scripts/load-backend.sh https://taskapp.versv.net
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get hpa
```
