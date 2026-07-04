# Terraform

This provisions three EC2 nodes for k3s on AWS.

1. Bootstrap remote state once:

   ```bash
   cp bootstrap/terraform.tfvars.example bootstrap/terraform.tfvars
   # Edit bootstrap/terraform.tfvars, especially state_bucket_name.
   terraform -chdir=bootstrap init
   terraform -chdir=bootstrap apply -var-file=terraform.tfvars
   ```

2. Copy `backend.example.hcl` to a local, ignored `backend.hcl` and fill in bucket/table names from bootstrap output:

   ```bash
   cp backend.example.hcl backend.hcl
   ```

3. Provision the cluster:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars for your public IP and SSH key.
   terraform init -backend-config=backend.hcl
   terraform apply -var-file=terraform.tfvars
   terraform output -json > ../../infra/ansible/terraform-output.json
   ```
