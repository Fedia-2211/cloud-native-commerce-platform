// Module: s3
// Purpose: Create S3 buckets for media and backups

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "media" {
  bucket        = "${var.project_name}-${var.environment}-media-${random_id.suffix.hex}"
  force_destroy = true
  tags          = { Name = "${var.project_name}-${var.environment}-media" }
}

resource "aws_s3_bucket_public_access_block" "media" {
  bucket                  = aws_s3_bucket.media.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "media" {
  bucket = aws_s3_bucket.media.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket" "backups" {
  bucket        = "${var.project_name}-${var.environment}-backups-${random_id.suffix.hex}"
  force_destroy = true
  tags          = { Name = "${var.project_name}-${var.environment}-backups" }
}

resource "aws_s3_bucket_public_access_block" "backups" {
  bucket                  = aws_s3_bucket.backups.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
