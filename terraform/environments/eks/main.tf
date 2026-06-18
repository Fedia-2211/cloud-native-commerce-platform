terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "cloud-native-commerce-platform"
    key    = "cloud-native-commerce/eks/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "main" {
  id = "vpc-0f6cbab5405b487fe"
}

locals {
  public_subnet_ids  = ["subnet-06b3c7cb0b796bc3f", "subnet-0d86a67278b3a42d9"]
  private_subnet_ids = ["subnet-0da2ee5a31f381336", "subnet-0ccb72c20f2cc126d"]
}

module "eks_security" {
  source       = "../../modules/eks-security"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = data.aws_vpc.main.id
  vpc_cidr     = data.aws_vpc.main.cidr_block
  your_ip_cidr = var.your_ip_cidr
}

module "eks" {
  source             = "../../modules/eks"
  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  kubernetes_version = "1.31"
  node_instance_type = var.node_instance_type
  node_desired_size  = 2
  node_min_size      = 2
  node_max_size      = 4
  private_subnet_ids = local.private_subnet_ids
  public_subnet_ids  = local.public_subnet_ids
  eks_cluster_sg_id  = module.eks_security.eks_cluster_sg_id
  your_ip_cidr       = var.your_ip_cidr
}

module "vault" {
  source           = "../../modules/vault-ec2"
  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = data.aws_vpc.main.id
  vpc_cidr         = data.aws_vpc.main.cidr_block
  public_subnet_id = local.public_subnet_ids[0]
  your_ip_cidr     = var.your_ip_cidr
  key_name         = var.key_name
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_eks" {
  security_group_id            = var.rds_sg_id
  referenced_security_group_id = module.eks_security.eks_nodes_sg_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Postgres from EKS nodes"
}