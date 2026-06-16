// ECR module variables
variable "project_name" {
  type        = string
  description = "Project name used for ECR repository naming"
}

variable "environment" {
  type        = string
  description = "Deployment environment used to scope repository names"
}
