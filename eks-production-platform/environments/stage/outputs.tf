output "aws_region" {
  description = "AWS region used by this environment."
  value       = var.aws_region
}

output "environment" {
  description = "Environment name."
  value       = var.environment
}

output "project_name" {
  description = "Project name used in resource names and tags."
  value       = var.project_name
}

output "cluster_version" {
  description = "Planned Kubernetes version input for the future EKS module."
  value       = var.cluster_version
}

output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC IPv4 CIDR."
  value       = module.vpc.vpc_cidr
}

output "availability_zones" {
  description = "Selected availability zones."
  value       = module.vpc.availability_zones
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs for future worker nodes."
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs."
  value       = module.vpc.nat_gateway_ids
}

output "s3_endpoint_id" {
  description = "S3 gateway VPC endpoint ID."
  value       = module.vpc_endpoints.s3_endpoint_id
}

output "eks_node_security_group_id" {
  description = "Worker node security group ID for the future EKS module."
  value       = module.security_groups.eks_node_security_group_id
}

output "eks_cluster_role_arn" {
  description = "EKS control plane IAM role ARN."
  value       = module.iam.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  description = "EKS worker node IAM role ARN."
  value       = module.iam.eks_node_role_arn
}
