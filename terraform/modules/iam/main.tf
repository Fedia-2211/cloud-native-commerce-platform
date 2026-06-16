// Module: iam
// Purpose: Create IAM roles, policies, and instance profile for k3s nodes and CI
# IAM role for k3s nodes to access AWS services
resource "aws_iam_role" "k3s_node" {
  name = "${var.project_name}-${var.environment}-k3s-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Allow nodes to pull from ECR
resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.k3s_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Allow nodes to read Secrets Manager
resource "aws_iam_role_policy" "secrets" {
  name = "secrets-manager-read"
  role = aws_iam_role.k3s_node.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = "arn:aws:secretsmanager:${var.aws_region}:*:secret:${var.project_name}/*"
    }]
  })
}

# Allow nodes to access S3 media bucket
resource "aws_iam_role_policy" "s3" {
  name = "s3-media-access"
  role = aws_iam_role.k3s_node.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::${var.project_name}-*",
        "arn:aws:s3:::${var.project_name}-*/*"
      ]
    }]
  })
}

# SSM for managing nodes without SSH (bonus: shows security maturity)
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.k3s_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "k3s_node" {
  name = "${var.project_name}-${var.environment}-k3s-node-profile"
  role = aws_iam_role.k3s_node.name
}

# IAM user for GitHub Actions to push to ECR
resource "aws_iam_user" "github_actions" {
  name = "${var.project_name}-${var.environment}-github-actions"
}

resource "aws_iam_user_policy_attachment" "github_ecr" {
  user       = aws_iam_user.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_access_key" "github_actions" {
  user = aws_iam_user.github_actions.name
}
