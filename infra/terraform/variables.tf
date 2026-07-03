variable "aws_region" {
  type        = string
  description = "AWS region for the capstone cluster."
}

variable "aws_profile" {
  type        = string
  description = "Local AWS CLI profile name."
  default     = null
}

variable "project_name" {
  type        = string
  description = "Name prefix for resources."
  default     = "capstone-phoenix"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
  default     = "10.42.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR block."
  default     = "10.42.1.0/24"
}

variable "admin_cidr" {
  type        = string
  description = "Your public IP CIDR for SSH and kube API access, for example 203.0.113.10/32."
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to the SSH public key used for EC2 access."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance size for all nodes."
  default     = "t3.small"
}

variable "node_count_workers" {
  type        = number
  description = "Number of k3s worker nodes."
  default     = 2
}
