// S3 module variables
variable "project_name" {
  type        = string
  description = "Project name used to name S3 buckets"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., 'production') used in bucket names"
}
