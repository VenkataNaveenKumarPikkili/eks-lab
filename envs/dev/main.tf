locals {
  name         = "${var.project}-${var.env}"   # eks-lab-dev
  cluster_name = local.name
}

module "network" {
  source = "../../modules/network"

  name               = local.name
  cluster_name       = local.cluster_name
  vpc_cidr           = var.vpc_cidr
  az_count           = var.az_count
  single_nat_gateway = var.single_nat_gateway
  enable_flow_logs   = var.enable_flow_logs
}

# Lesson 3 will add:
# module "eks" {
#   source          = "../../modules/eks"
#   vpc_id          = module.network.vpc_id
#   subnet_ids      = module.network.private_subnets
#   ...
# }
