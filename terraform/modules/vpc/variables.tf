// VPC module variables
variable "project_name" {
  type        = string
  description = "Project name used to tag and name resources"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., 'dev', 'staging', 'production')"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.2.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_subnet_a_cidr" {
  type        = string
  default     = "10.2.1.0/24"
  description = "CIDR for public subnet A"
}

variable "public_subnet_b_cidr" {
  type        = string
  default     = "10.2.2.0/24"
  description = "CIDR for public subnet B"
}

variable "private_subnet_a_cidr" {
  type        = string
  default     = "10.2.3.0/24"
  description = "CIDR for private subnet A"
}

variable "private_subnet_b_cidr" {
  type        = string
  default     = "10.2.4.0/24"
  description = "CIDR for private subnet B"
}
