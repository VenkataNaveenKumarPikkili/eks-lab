variable "name" {
  description = "Prefix for resource names, e.g. eks-lab-dev"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name, used for Karpenter subnet discovery tags"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR (/16 recommended). Must be unique across environments."
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0)) && tonumber(split("/", var.vpc_cidr)[1]) <= 16
    error_message = "vpc_cidr must be a valid CIDR of /16 or larger."
  }
}

variable "az_count" {
  description = "Number of AZs to use (2–3)"
  type        = number
  default     = 3
  validation {
    condition     = var.az_count >= 2 && var.az_count <= 3
    error_message = "EKS needs at least 2 AZs; this module supports up to 3."
  }
}

variable "single_nat_gateway" {
  description = "true = one shared NAT (cheap). false = one NAT per AZ (HA)."
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  type    = bool
  default = false
}

variable "flow_log_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  description = "Extra tags for all resources"
  type        = map(string)
  default     = {}
}
