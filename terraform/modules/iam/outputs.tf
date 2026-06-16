// Outputs for the IAM module
output "instance_profile_name" { value = aws_iam_instance_profile.k3s_node.name }
output "github_actions_key_id" { value = aws_iam_access_key.github_actions.id }
output "github_actions_secret" {
  value     = aws_iam_access_key.github_actions.secret
  sensitive = true
}
