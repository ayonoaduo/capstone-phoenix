# Ansible

Installs k3s and platform controllers on the Terraform-created nodes.

```bash
ansible-galaxy collection install -r infra/ansible/requirements.yml
ansible-playbook -i infra/ansible/inventory.ini infra/ansible/site.yml
ansible-playbook -i infra/ansible/inventory.ini infra/ansible/site.yml
```

The second run checks idempotency. The playbook also writes `infra/ansible/kubeconfig` for local `kubectl`.
