variable "project_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "ssh_public_key" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "worker_count" {
  type = number
}
