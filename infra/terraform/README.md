# Terraform

AWS infrastructure for the k3s cluster.

## Remote State Bootstrap

```bash
cp infra/terraform/bootstrap/terraform.tfvars.example infra/terraform/bootstrap/terraform.tfvars
# edit state_bucket_name, region, profile
terraform -chdir=infra/terraform/bootstrap init
terraform -chdir=infra/terraform/bootstrap apply -var-file=terraform.tfvars
```

## Cluster

```bash
cp infra/terraform/backend.example.hcl infra/terraform/backend.hcl
cp infra/terraform/terraform.tfvars.example infra/terraform/terraform.tfvars
# edit backend.hcl and terraform.tfvars
terraform -chdir=infra/terraform init -backend-config=backend.hcl
terraform -chdir=infra/terraform apply -var-file=terraform.tfvars
./scripts/render-inventory.sh
```

Local `backend.hcl`, `terraform.tfvars`, and state files are ignored.
