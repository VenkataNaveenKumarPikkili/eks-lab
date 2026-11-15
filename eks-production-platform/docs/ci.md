# GitHub Actions setup

The workflow always checks `terraform fmt -check -recursive` and initializes/validates each environment root and the state-bucket bootstrap without a backend. These jobs need no AWS credentials.

The optional dev plan job runs only when all repository variables below are configured:

- `AWS_ROLE_ARN`: IAM role trusted for GitHub OIDC
- `AWS_REGION`: AWS region
- `TF_STATE_BUCKET`: secured state bucket name
- `TF_STATE_KEY`: exact dev state object key

The plan job initializes the configured remote backend with S3 lockfile support, assumes the OIDC role, and runs `terraform plan`. It never applies. Fork pull requests skip the plan job. A plan requires access to read the current state, manage the transient lock object, and read the AWS metadata/resources used by Terraform; scope the role to the required bucket/key and read-only infrastructure actions.

Restrict the IAM trust policy to this repository and protected branches/environments. The repository variable alone does not grant AWS access. Plan logs and state are sensitive operational information; limit workflow access. If variables are absent, formatting and validation still run and the plan is skipped.
