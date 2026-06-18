// Module: ecr
// Purpose: Create ECR repositories used to store container images for services
# One ECR repo per service
locals {
  repositories = [
    "saleor-core",
    "saleor-worker",
    "saleor-storefront",
    "saleor-dashboard"
  ]
}

resource "aws_ecr_repository" "repos" {
  for_each             = toset(local.repositories)
  name                 = "${var.project_name}/${each.key}"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = "${var.project_name}/${each.key}" }
}

resource "aws_ecr_lifecycle_policy" "repos" {
  for_each   = aws_ecr_repository.repos
  repository = each.value.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = { type = "expire" }
    }]
  })
}