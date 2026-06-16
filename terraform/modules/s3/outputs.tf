output "media_bucket_name" { value = aws_s3_bucket.media.bucket }
output "backups_bucket_name" { value = aws_s3_bucket.backups.bucket }
// Outputs for the S3 module
output "media_bucket_arn" { value = aws_s3_bucket.media.arn }
output "backups_bucket_arn" { value = aws_s3_bucket.backups.arn }
