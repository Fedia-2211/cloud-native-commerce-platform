// Module variables for compute (k3s servers and agents)

// Identity / naming
variable "project_name" {
  type        = string
  description = "Name of the project used to prefix resources (e.g., 'myproject')"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., 'dev', 'staging', 'production')"
}

// Network
variable "public_subnet_id" {
  type        = string
  description = "ID of the public subnet for public-facing instances"
}

variable "private_subnet_id" {
  type        = string
  description = "ID of the private subnet for internal instances"
}

// Security
variable "k3s_server_sg_id" {
  type        = string
  description = "Security group ID for k3s server (control plane) nodes"
}

variable "k3s_agent_sg_id" {
  type        = string
  description = "Security group ID for k3s agent (worker) nodes"
}

// Access & IAM
variable "key_name" {
  type        = string
  description = "EC2 key pair name for SSH access to instances"
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile name or ARN to attach to instances"
}

// Instance sizing
variable "server_instance_type" {
  type        = string
  default     = "t3.large"
  description = "EC2 instance type for server (control plane) nodes"
}

variable "agent_instance_type" {
  type        = string
  default     = "t3.large"
  description = "EC2 instance type for agent (worker) nodes"
}
