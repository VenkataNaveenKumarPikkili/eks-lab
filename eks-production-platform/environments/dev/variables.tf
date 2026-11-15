variable "aws_region" {
  description = "AWS deployment region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition = contains(
      ["dev", "qa", "stage", "prod"],
      var.environment
    )

    error_message = "Environment must be dev, qa, stage, or prod."
  }
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "eks-platform"
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "vpc_cidr" {
  description = "Dev VPC CIDR"
  type        = string
}

variable "az_count" {
  description = "Number of Availability Zones"
  type        = number
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway"
  type        = bool
}