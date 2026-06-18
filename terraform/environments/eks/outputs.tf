output "eks_cluster_name"     { value = module.eks.cluster_name }
output "eks_cluster_endpoint" { value = module.eks.cluster_endpoint }
output "vault_public_ip"      { value = module.vault.vault_public_ip }
output "vault_url"            { value = module.vault.vault_url }

output "kubectl_config_command" {
  value = "aws eks update-kubeconfig --region us-east-1 --name ${module.eks.cluster_name}"
}
