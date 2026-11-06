project            = "eks-lab"
env                = "prod"
region             = "us-east-1"
account_id         = "111111111111"   # ideally a SEPARATE AWS account (see below)
vpc_cidr           = "10.2.0.0/16"    # no overlap with dev
az_count           = 3
single_nat_gateway = false   # HA: one NAT per AZ
enable_flow_logs   = true    # audit trail
