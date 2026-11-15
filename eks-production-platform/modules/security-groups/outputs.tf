output "eks_node_security_group_id" {

  description = "EKS worker node security group ID"

  value = aws_security_group.eks_nodes.id

}

output "eks_node_security_group_name" {

  description = "EKS worker node security group name"

  value = aws_security_group.eks_nodes.name

}