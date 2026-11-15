provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "eks-production-platform"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "DevOps"
    }
  }
}