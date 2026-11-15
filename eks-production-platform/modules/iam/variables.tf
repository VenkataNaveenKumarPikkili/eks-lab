variable "name_prefix" {
  description = "Prefix used for IAM role naming"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}