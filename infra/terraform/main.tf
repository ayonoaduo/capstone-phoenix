module "network" {
  source             = "./modules/network"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "security_group" {
  source       = "./modules/security_group"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  vpc_cidr     = var.vpc_cidr
  admin_cidr   = var.admin_cidr
}

module "compute" {
  source             = "./modules/compute"
  project_name       = var.project_name
  subnet_id          = module.network.public_subnet_id
  security_group_ids = [module.security_group.node_security_group_id]
  ssh_public_key     = file(var.ssh_public_key_path)
  instance_type      = var.instance_type
  worker_count       = var.node_count_workers
}
