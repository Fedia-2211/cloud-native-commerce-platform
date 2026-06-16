variable "project_name" {
  type        = string
  default     = "cloud-native-commerce-platform"
  description = "Top-level project name used across modules"
}

variable "environment" {
  type        = string
  default     = "production"
  description = "Deployment environment"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy resources in"
}

variable "your_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR format for SSH/kubectl access"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name for SSH access to instances"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master DB password (sensitive)"
}

variable "server_instance_type" {
  type        = string
  default     = "m7i-flex.large"
  description = "Instance type for control-plane/server nodes"
}

variable "agent_instance_type" {
  type        = string
  default     = "m7i-flex.large"
  description = "Instance type for worker/agent nodes"
}
