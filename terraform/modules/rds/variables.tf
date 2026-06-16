// RDS module variables
variable "project_name" {
  type        = string
  description = "Project name used for RDS tagging and naming"
}

variable "environment" {
  type        = string
  description = "Deployment environment for the database"
}

variable "private_subnet_a_id" {
  type        = string
  description = "Private subnet A ID for the RDS subnet group"
}

variable "private_subnet_b_id" {
  type        = string
  description = "Private subnet B ID for the RDS subnet group"
}

variable "rds_sg_id" {
  type        = string
  description = "Security group ID to attach to the RDS instance"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "RDS instance class (size)"
}

variable "db_name" {
  type        = string
  default     = "saleor"
  description = "Initial database name"
}

variable "db_username" {
  type        = string
  default     = "saleor_admin"
  description = "Master username for the RDS instance"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master password for the RDS instance (sensitive)"
}
