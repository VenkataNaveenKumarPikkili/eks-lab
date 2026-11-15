provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "eks-production-platform"
      ManagedBy = "Terraform"
      Purpose   = "Terraform Remote Backend"
    }
  }
}