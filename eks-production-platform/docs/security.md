# Security notes

- **Credentials:** Use short-lived local credentials. GitHub Actions uses OIDC only when explicitly configured; never add long-lived AWS keys as repository secrets.
- **State:** Terraform state may contain sensitive values. The bootstrap bucket enables versioning, server-side encryption, public-access blocking, ownership controls, HTTPS-only access, and an S3 lockfile. Restrict bucket and KMS access (if KMS is adopted) to the state operators and CI role.
- **Separate state:** Keep one state key per environment. Production state access should be limited to the production operations role.
- **Local files:** `.tfstate`, `.tfplan`, `.tfvars`, `backend.hcl`, `.terraform/`, and ZIP archives are ignored. Keep `.terraform.lock.hcl` committed to make provider selection reproducible.
- **History:** Removing a local file from tracking does not erase it from earlier Git commits. If any credential was ever committed, rotate it immediately and follow a repository history cleanup procedure before making the repository public.
- **IAM:** Control plane and node trust are separate. Review AWS managed policies and least privilege. Workloads should use dedicated identities, not node credentials.
- **Network:** Nodes are expected to use private subnets. The current node security group allows all outbound IPv4 and self-referenced node traffic. The EKS API endpoint policy is not implemented yet.
- **Repository:** Protect `main`, require review and successful checks, and enable secret scanning and push protection. Inspect all files and Git history before changing repository visibility.

This project is a learning baseline, not a security assessment.
