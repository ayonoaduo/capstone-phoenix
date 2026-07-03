variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type    = string
  default = null
}

variable "state_bucket_name" {
  type = string
}

variable "lock_table_name" {
  type    = string
  default = "capstone-phoenix-tf-locks"
}
