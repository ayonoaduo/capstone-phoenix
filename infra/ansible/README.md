# Ansible

Render inventory from Terraform:

```bash
terraform -chdir=../terraform output -raw ansible_inventory > inventory.ini
```

Then install the cluster:

```bash
ansible-playbook -i inventory.ini site.yml
```

Run it twice. The second run should be idempotent apart from package cache checks.
