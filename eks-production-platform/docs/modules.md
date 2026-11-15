# Terraform module guide

Reusable modules live under `modules/`; provider configuration and environment-specific decisions live in each environment root.

| Module | Responsibility | Inputs | Outputs |
|---|---|---|---|
| `vpc` | VPC, IGW, AZ selection, public/private subnets and route tables, EIPs/NAT gateways | Name prefix, VPC CIDR, AZ count, NAT topology, tags | VPC ID/CIDR, AZs, subnet IDs/CIDRs, route tables, NAT IDs/IPs |
| `vpc-endpoints` | S3 gateway endpoint associated with private route tables | VPC ID, private route table IDs, region, tags | Endpoint ID |
| `security-groups` | Worker-node security group, self-referenced node ingress and outbound rule | VPC ID, name prefix, tags | Security group ID/name |
| `iam` | Separate EKS control plane and EC2 node roles with AWS managed policy attachments | Name prefix, tags | Role ARNs/names |

## Composition

Each environment root uses the same module composition and values from its own ignored `terraform.tfvars`. Provider `default_tags` now use `var.project_name`, matching the explicit root tag map. This avoids the earlier `eks-platform` versus `eks-production-platform` discrepancy on security group rules.

## Design notes

- AZs are discovered and sorted, with optional exclusion by AZ ID. This avoids assuming every account has the same AZ name-to-zone mapping.
- The VPC module creates one NAT gateway when `single_nat_gateway=true`, otherwise one per AZ. Private subnets route through the selected NAT topology.
- The node security group currently allows all outbound IPv4 and all traffic among nodes in that group. Restrict egress after defining required AWS endpoints and application destinations.
- The node role has worker-node and ECR pull managed policies. Do not use the node role for application permissions; add EKS Pod Identity or IRSA with dedicated workload roles.
- The cluster/node role outputs are prepared for a future EKS module, but those modules are not implemented in the current checkout.

## Environment isolation

`dev`, `qa`, `stage`, and `prod` are independent Terraform roots. The backend key must differ for each environment. Use separate IAM access boundaries for production state and deployment roles. Do not share state files or copy account-specific backend files into Git.
