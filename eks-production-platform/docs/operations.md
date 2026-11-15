# Operations and learning roadmap

## Before planning

1. Confirm the active AWS account and region using your short-lived AWS identity.
2. Check the VPC CIDR against existing VPCs, VPNs, peering, and corporate networks.
3. Confirm the selected AZ count and service quotas.
4. Review NAT gateway topology and expected recurring costs.
5. Inspect the environment's backend key to ensure it is isolated.

## Safe change workflow

1. Run `terraform fmt -check -recursive` and `terraform validate`.
2. Plan from the intended environment root with its local variables and backend configuration.
3. Review all creates, updates, replacements, and destroys. Confirm the account, tags, CIDRs, and environment.
4. Apply only through an explicitly approved human process. The supplied GitHub workflow never applies.

## State and drift

Use the same environment root and backend to inspect drift. Do not edit state manually as a first response. Preserve state backups and restrict access during recovery. CIDR, subnet, IAM role, and cluster identity changes can cause replacements or downtime; inspect the plan before proceeding.

## Troubleshooting

- **Credential errors:** Refresh the AWS SSO session or check the GitHub OIDC trust policy and role.
- **Unavailable AZ:** Confirm the configured AZ count is available in the selected region/account; AZ IDs can differ between accounts.
- **CIDR conflicts:** Use non-overlapping VPC ranges and ensure subnets remain within the VPC CIDR.
- **Unexpected tags:** Provider defaults and explicit module tags should use the same project/environment values.
- **Unexpected replacement:** Stop and confirm the selected state key and environment before changing immutable arguments.

## Roadmap

1. Add the EKS control plane with private endpoint access and access entries.
2. Add managed node groups in private subnets, then EKS add-ons.
3. Add OIDC workload identity (Pod Identity or IRSA), ECR, and observability.
4. Add tests for subnet calculations, module contracts, and policy boundaries.
5. Review and plan each environment independently before any apply.
