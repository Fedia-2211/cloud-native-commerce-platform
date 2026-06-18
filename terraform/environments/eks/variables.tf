variable "project_name" {
  type    = string
  default = "commerce-platform"
}

variable "environment" {
  type    = string
  default = "eks"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "your_ip_cidr" {
  type = string
}

variable "key_name" {
  type = string
}

variable "node_instance_type" {
  type    = string
  default = "m7i-flex.large"
}

variable "rds_sg_id" {
  type        = string
  description = "Existing RDS security group ID from k3s production"
}