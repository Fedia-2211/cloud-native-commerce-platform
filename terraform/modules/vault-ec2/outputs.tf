output "vault_public_ip"   { value = aws_instance.vault.public_ip }
output "vault_private_ip"  { value = aws_instance.vault.private_ip }
output "vault_url"         { value = "http://${aws_instance.vault.private_ip}:8200" }
output "vault_sg_id"       { value = aws_security_group.vault.id }
