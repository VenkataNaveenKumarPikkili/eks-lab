# Cost and availability notes

AWS pricing varies by region, traffic, and time. Use the AWS Pricing Calculator and Cost Explorer for current estimates; this page names cost drivers, not a quote.

- **NAT Gateway:** Billed per gateway-hour and data processed. One shared gateway reduces fixed cost but is a single-AZ dependency and may cause cross-AZ data charges. One per AZ improves resilience and increases fixed cost.
- **EKS:** The cluster control plane has an ongoing hourly charge. Extended Kubernetes version support can add charges; plan upgrades and remain within standard support.
- **Compute:** Managed node EC2 instances, EBS, load balancers, and transfer add cost. EKS nodes are not implemented yet.
- **VPC endpoints:** S3 gateway endpoints have no hourly endpoint charge; interface endpoints have hourly and data-processing charges.
- **Logs and metrics:** CloudWatch ingestion, retention, metrics, and tracing can become material. Choose retention deliberately.
- **State bucket:** S3 storage and requests are generally small but not free. Versioning retains old state versions, so configure lifecycle/retention and protect recovery versions.
- **Tags and budgets:** The common tags include `Project`, `Environment`, `Owner`, and `ManagedBy`. Add account budgets and alerts before creating environments.

The example configuration uses a single NAT gateway for dev/QA/stage and one per AZ for production. Confirm this tradeoff fits each environment.
