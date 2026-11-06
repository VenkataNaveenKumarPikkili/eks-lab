output "vpc_id"          { value = module.vpc.vpc_id }
output "vpc_cidr"        { value = module.vpc.vpc_cidr_block }
output "azs"             { value = local.azs }
output "private_subnets" { value = module.vpc.private_subnets }
output "public_subnets"  { value = module.vpc.public_subnets }
output "intra_subnets"   { value = module.vpc.intra_subnets }
output "nat_public_ips"  { value = module.vpc.nat_public_ips }
