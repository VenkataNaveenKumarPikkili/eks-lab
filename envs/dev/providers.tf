provider "aws" {
  region = var.region

  # Safety net: refuse to run against the wrong AWS account
  allowed_account_ids = [var.account_id]

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.env
      ManagedBy   = "terraform"
    }
  }
}
