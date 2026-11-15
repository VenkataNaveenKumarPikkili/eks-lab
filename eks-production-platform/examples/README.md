# Safe examples

- Each `environments/<name>/terraform.tfvars.example` shows the inputs for that independent root. Copy it to ignored `terraform.tfvars`, then set a non-overlapping CIDR and supported EKS version.
- Each environment's `backend.hcl.example` shows its unique S3 state key. Copy it to ignored `backend.hcl` and replace the bucket placeholder after the state bucket is provisioned.

Never commit the real `.tfvars` or backend settings. These examples are not deployment approval; review the plan and cost first.
