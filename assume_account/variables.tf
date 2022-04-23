# General
variable "region" {
  description = "Region to deploy into"
  type        = string
}

variable "permissions_boundary" {
  description = "IAM Permissions Boundary for the source account"
  type        = string
}

variable "vpc_id" {
  description = "VPC for the shared account"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the shared account"
  type        = list(string)
}

variable "account_id" {
  description = "Account ID for the source account"
  type        = string
}

variable "account_name" {
  description = "Account name for the source account"
  type        = string
}

variable "component_name" {
  description = "Name of the component"
  type        = string
}

# EC2
variable "ec2_instance_type" {
  description = "EC2 instance type"
  default     = "t3a.small"
  type        = string
}
