// IAM module variables
variable "project_name" {
  type        = string
  description = "Project name used for IAM resource naming"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/staging/prod)"
}

variable "aws_region" {
  type        = string
  description = "AWS region where IAM resources will be created"
}
