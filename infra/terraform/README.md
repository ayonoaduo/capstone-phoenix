# Terraform

This provisions three EC2 nodes for k3s on AWS.

1. Bootstrap remote state once:

   ```bash
   terraform -chdir=bootstrap init
   terraform -chdir=bootstrap apply
   ```

2. Copy `backend.example.hcl` to a local, ignored `backend.hcl` and fill in bucket/table names from bootstrap output.

3. Provision the cluster:

   ```bash
   terraform init -backend-config=backend.hcl
   terraform apply
   terraform output -json > ../../infra/ansible/terraform-output.json
   ```
