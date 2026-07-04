# Runbook

## 1. Bootstrap Terraform State

```bash
cp infra/terraform/bootstrap/terraform.tfvars.example infra/terraform/bootstrap/terraform.tfvars
terraform -chdir=infra/terraform/bootstrap init
terraform -chdir=infra/terraform/bootstrap apply -var-file=terraform.tfvars
```

Copy the created bucket/table values into `infra/terraform/backend.hcl`.

## 2. Provision AWS Nodes

```bash
cp infra/terraform/backend.example.hcl infra/terraform/backend.hcl
cp infra/terraform/terraform.tfvars.example infra/terraform/terraform.tfvars
terraform -chdir=infra/terraform init -backend-config=backend.hcl
terraform -chdir=infra/terraform apply -var-file=terraform.tfvars
./scripts/render-inventory.sh
```

## 3. Create App Secret

```bash
AWS_REGION=us-west-2 \
DATABASE_USER=taskapp \
DATABASE_PASSWORD='replace-me' \
SECRET_KEY='replace-me' \
TASKAPP_ADMIN_USERNAME=admin \
TASKAPP_ADMIN_PASSWORD='replace-me' \
TASKAPP_DEMO_USERNAME=student1 \
TASKAPP_DEMO_PASSWORD='replace-me' \
./scripts/create-taskapp-secret.sh
```

## 4. Install k3s And Platform

```bash
ansible-galaxy collection install -r infra/ansible/requirements.yml
ansible-playbook -i infra/ansible/inventory.ini infra/ansible/site.yml
ansible-playbook -i infra/ansible/inventory.ini infra/ansible/site.yml
```

## 5. DNS

Point `taskapp.<domain>` to the public node IP used by Traefik.

```bash
terraform -chdir=infra/terraform output control_plane_public_ip
```

## 6. Start GitOps

```bash
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/platform-secret-store.yaml
kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/taskapp.yaml
```

## Verify

```bash
kubectl --kubeconfig infra/ansible/kubeconfig get nodes -o wide
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get pods -o wide
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp get hpa
curl -vI https://taskapp.<domain>
```

## Recovery

- Worker failure: replace with Terraform, rerun Ansible, let Kubernetes reschedule.
- Bad app deploy: revert the image tag commit and let Argo CD sync.
- Postgres pod deletion: StatefulSet recreates the pod and remounts the PVC.
