output "eks_cluster_sg_id" { value = aws_security_group.eks_cluster.id }
output "eks_nodes_sg_id"   { value = aws_security_group.eks_nodes.id }
output "eks_alb_sg_id"     { value = aws_security_group.eks_alb.id }
output "rds_eks_sg_id"     { value = aws_security_group.rds_eks.id }
