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


variable "role_arns" {
  description = "The role in the assume account that is allowed to assume role in the source account"
  type        = list
}

variable "cw_arn" {
  description = "The CloudWatch log group ARN to be accessed"
  type        = string
}
