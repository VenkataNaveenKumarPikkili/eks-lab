variable "vpc_id" {
  description = "VPC ID where the endpoint will be created"
  type        = string
}

variable "private_route_table_ids" {
  description = "Private route table IDs associated with the endpoint"
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}