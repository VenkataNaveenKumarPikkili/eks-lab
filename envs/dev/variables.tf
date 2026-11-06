variable "project"            { type = string }
variable "env"                { type = string }
variable "region"             { type = string }
variable "account_id"         { type = string }
variable "vpc_cidr"           { type = string }
variable "az_count"           { type = number }
variable "single_nat_gateway" { type = bool }
variable "enable_flow_logs"   { type = bool }
