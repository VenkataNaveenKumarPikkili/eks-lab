output "eks_cluster_role_arn" {

  description = "EKS cluster IAM role ARN"

  value = aws_iam_role.eks_cluster.arn
}

output "eks_cluster_role_name" {

  description = "EKS cluster IAM role name"

  value = aws_iam_role.eks_cluster.name
}

output "eks_node_role_arn" {

  description = "EKS worker node IAM role ARN"

  value = aws_iam_role.eks_node.arn
}

output "eks_node_role_name" {

  description = "EKS worker node IAM role name"

  value = aws_iam_role.eks_node.name
}