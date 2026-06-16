output "alb_sg_id" { value = aws_security_group.alb.id }
// Outputs for the security module
output "k3s_server_sg_id" { value = aws_security_group.k3s_server.id }
output "k3s_agent_sg_id" { value = aws_security_group.k3s_agent.id }
output "rds_sg_id" { value = aws_security_group.rds.id }
