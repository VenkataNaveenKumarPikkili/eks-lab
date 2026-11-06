terraform {
  required_version = ">= 1.10"

  required_providers {
    aws        = { source = "hashicorp/aws",        version = "~> 6.0" }
    helm       = { source = "hashicorp/helm",       version = "~> 3.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.38" }
  }

  backend "s3" {
    bucket       = "eks-lab-tfstate-<YOUR_ACCOUNT_ID>"
    key          = "dev/terraform.tfstate"     # ← different key per env
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
