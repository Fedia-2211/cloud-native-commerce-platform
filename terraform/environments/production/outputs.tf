output "k3s_server_public_ip" { value = module.compute.k3s_server_public_ip }
output "k3s_server_private_ip" { value = module.compute.k3s_server_private_ip }
output "k3s_agent_private_ip" { value = module.compute.k3s_agent_private_ip }
// Environment production outputs
output "k3s_server_id" { value = module.compute.k3s_server_id }
output "k3s_agent_id" { value = module.compute.k3s_agent_id }
output "db_endpoint" { value = module.rds.db_endpoint }
output "db_address" { value = module.rds.db_address }
output "media_bucket" { value = module.s3.media_bucket_name }
output "backups_bucket" { value = module.s3.backups_bucket_name }
output "ecr_repository_urls" { value = module.ecr.repository_urls }
output "vpc_id" { value = module.vpc.vpc_id }
output "github_actions_key_id" { value = module.iam.github_actions_key_id }
output "github_actions_secret" {
  value     = module.iam.github_actions_secret
  sensitive = true
}
