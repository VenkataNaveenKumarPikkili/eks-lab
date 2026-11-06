terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 6.0" }  # a range here, NOT a pin; the root pins it
  }
}
