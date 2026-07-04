# Runbook

## Provision From Zero

1. Replace `CHANGE_ME` placeholders in Terraform, Kustomize, Argo CD, and docs.
2. Create Terraform state:

   ```bash
   cp infra/terraform/bootstrap/terraform.tfvars.example infra/terraform/bootstrap/terraform.tfvars
   # Edit infra/terraform/bootstrap/terraform.tfvars, especially state_bucket_name.
   terraform -chdir=infra/terraform/bootstrap init
   terraform -chdir=infra/terraform/bootstrap apply -var-file=terraform.tfvars
   ```

3. Fill `infra/terraform/backend.hcl` from bootstrap output.
4. Apply infrastructure:

   ```bash
   cp infra/terraform/backend.example.hcl infra/terraform/backend.hcl
   cp infra/terraform/terraform.tfvars.example infra/terraform/terraform.tfvars
   # Edit backend.hcl and terraform.tfvars for your AWS account, public IP, and SSH key.
   terraform -chdir=infra/terraform init -backend-config=backend.hcl
   terraform -chdir=infra/terraform apply -var-file=terraform.tfvars
   ./scripts/render-inventory.sh
   ```

5. Create the AWS Secrets Manager secret:

   ```bash
   AWS_REGION=us-west-2 DATABASE_USER=taskapp DATABASE_PASSWORD='...' SECRET_KEY='...' TASKAPP_ADMIN_USERNAME=admin TASKAPP_ADMIN_PASSWORD='...' TASKAPP_DEMO_USERNAME=student1 TASKAPP_DEMO_PASSWORD='...' ./scripts/create-taskapp-secret.sh
   ```

6. Install k3s and platform controllers:

   ```bash
   cd infra/ansible
   ansible-galaxy collection install -r requirements.yml
   ansible-playbook -i inventory.ini site.yml
   ansible-playbook -i inventory.ini site.yml
   ```

7. Apply Argo CD applications once:

   ```bash
   kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/platform-secret-store.yaml
   kubectl --kubeconfig infra/ansible/kubeconfig apply -f gitops/apps/taskapp.yaml
   ```

## Deploy

Push to `main`. GitHub Actions builds pinned GHCR images and commits the new tag into `manifests/overlays/prod/kustomization.yaml`. Argo CD auto-syncs the commit.

## Scale

Backend scaling is automatic through HPA. Manual emergency scale:

```bash
kubectl --kubeconfig infra/ansible/kubeconfig -n taskapp scale deploy/taskapp-backend --replicas=4
```

Commit a manifest change afterward so GitOps remains the source of truth.

## Roll Back

Revert the image tag bump commit and push. Argo CD will sync the previous pinned image tag.

## Recoveries

- Dead worker: drain if reachable, terminate/replace the EC2 instance through Terraform, then rerun Ansible. PDBs keep at least one frontend/backend pod available.
- Dead backend pod: Kubernetes recreates it; readiness keeps traffic away until `/api/health` passes.
- Bad migration: revert the migration/image commit, restore Postgres from backup if the migration changed data destructively, then let Argo CD sync.
- Postgres pod delete: StatefulSet recreates the pod and remounts the PVC.
