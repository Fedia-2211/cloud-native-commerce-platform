output "db_endpoint" { value = aws_db_instance.postgres.endpoint }
output "db_address" { value = aws_db_instance.postgres.address }
output "db_name" { value = aws_db_instance.postgres.db_name }
// Outputs for the RDS module
output "rds_endpoint" { value = aws_db_instance.postgres.endpoint }
output "rds_port" { value = aws_db_instance.postgres.port }
