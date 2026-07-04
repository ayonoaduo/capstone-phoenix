variable "aws_region" {
  type        = string
  description = "AWS region where the remote state bucket and lock table will be created."
}

# variable "aws_profile" {
#   type        = string
#   description = "Local AWS CLI profile to use. Set to null to use default AWS environment credentials."
#   default     = null
# }

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform remote state."
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table name for Terraform state locking."
  default     = "capstone-phoenix-tf-locks"
}
