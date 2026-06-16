// Environment: production
// Purpose: Wire modules together and configure providers/backends for production

terraform {
  required_version = ">= 1.5"
  required_providers {
    aws    = { source = "hashicorp/aws", version = "~> 5.0" }
    random = { source = "hashicorp/random", version = "~> 3.0" }
  }

  backend "s3" {
    bucket = "cloud-native-commerce-platform"
    key    = "cloud-native-commerce/production/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source       = "../../modules/vpc"
  project_name = var.project_name
  environment  = var.environment
}

module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
}

module "security" {
  source       = "../../modules/security"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr
  your_ip_cidr = var.your_ip_cidr
}

module "compute" {
  source               = "../../modules/compute"
  project_name         = var.project_name
  environment          = var.environment
  public_subnet_id     = module.vpc.public_subnet_a_id
  private_subnet_id    = module.vpc.private_subnet_a_id
  k3s_server_sg_id     = module.security.k3s_server_sg_id
  k3s_agent_sg_id      = module.security.k3s_agent_sg_id
  key_name             = var.key_name
  iam_instance_profile = module.iam.instance_profile_name
  server_instance_type = var.server_instance_type
  agent_instance_type  = var.agent_instance_type
}

module "rds" {
  source              = "../../modules/rds"
  project_name        = var.project_name
  environment         = var.environment
  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  rds_sg_id           = module.security.rds_sg_id
  db_password         = var.db_password
}

module "s3" {
  source       = "../../modules/s3"
  project_name = var.project_name
  environment  = var.environment
}

module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
  environment  = var.environment
}
