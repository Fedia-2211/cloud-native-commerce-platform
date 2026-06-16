// Security module variables
variable "project_name" {
  type        = string
  description = "Project name used for tagging security resources"
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/staging/production)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the VPC (used for rule scoping)"
}

variable "your_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR format (e.g., '203.0.113.5/32') for SSH access rules"
}
