locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name_prefix        = local.name_prefix
  vpc_cidr           = var.vpc_cidr
  az_count           = var.az_count
  single_nat_gateway = var.single_nat_gateway
  tags               = local.common_tags
}

module "vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  name_prefix             = local.name_prefix
  vpc_id                  = module.vpc.vpc_id
  private_route_table_ids = module.vpc.private_route_table_ids
  aws_region              = var.aws_region
  tags                    = local.common_tags
}

module "security_groups" {
  source = "../../modules/security-groups"

  name_prefix = local.name_prefix
  vpc_id      = module.vpc.vpc_id
  tags        = local.common_tags
}

module "iam" {
  source = "../../modules/iam"

  name_prefix = local.name_prefix
  tags        = local.common_tags
}
