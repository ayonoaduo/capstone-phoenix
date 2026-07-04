output "control_plane_public_ip" {
  value       = module.compute.control_plane_public_ip
  description = "Public IP of the k3s server."
}

output "control_plane_private_ip" {
  value       = module.compute.control_plane_private_ip
  description = "Private IP of the k3s server."
}

output "worker_public_ips" {
  value       = module.compute.worker_public_ips
  description = "Public IPs of k3s agents."
}

output "worker_private_ips" {
  value       = module.compute.worker_private_ips
  description = "Private IPs of k3s agents."
}

output "ansible_inventory" {
  value = templatefile("${path.module}/templates/inventory.ini.tftpl", {
    control_public_ip       = module.compute.control_plane_public_ip
    control_private_ip      = module.compute.control_plane_private_ip
    worker_public_ips       = module.compute.worker_public_ips
    worker_private_ips      = module.compute.worker_private_ips
    ssh_private_key_path    = trimsuffix(var.ssh_public_key_path, ".pub")
  })
  description = "Render this to infra/ansible/inventory.ini."
}
