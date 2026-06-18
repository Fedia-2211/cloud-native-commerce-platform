# ─── EKS Cluster Security Group ──────────────────────────────────────────────
# Controls traffic to/from the EKS control plane
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project_name}-${var.environment}-eks-sg-cluster"
  description = "EKS cluster control plane"
  vpc_id      = var.vpc_id

  ingress {
    description = "API server from admin"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.your_ip_cidr]
  }

  ingress {
    description = "API server from nodes"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-eks-sg-cluster" }
}

# ─── EKS Nodes Security Group ─────────────────────────────────────────────────
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-${var.environment}-eks-sg-nodes"
  description = "EKS worker nodes"
  vpc_id      = var.vpc_id

  # Nodes talk to each other (all ports)
  ingress {
    description = "Node to node"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Control plane to nodes
  ingress {
    description     = "Control plane to nodes"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  # ALB to nodes
  ingress {
    description     = "ALB to nodes"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eks_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-eks-sg-nodes" }
}

# ─── ALB Security Group ────────────────────────────────────────────────────────
resource "aws_security_group" "eks_alb" {
  name        = "${var.project_name}-${var.environment}-eks-sg-alb"
  description = "ALB for EKS ingress"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-eks-sg-alb" }
}

# ─── RDS Security Group update ────────────────────────────────────────────────
# Allow EKS nodes to access existing RDS
resource "aws_security_group" "rds_eks" {
  name        = "${var.project_name}-${var.environment}-eks-sg-rds"
  description = "Allow EKS nodes to reach RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Postgres from EKS nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-${var.environment}-eks-sg-rds" }
}
