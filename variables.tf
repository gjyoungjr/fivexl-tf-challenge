# variables.tf
# Input variables allow customization between environments (dev/prod)

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "fivexl-challenge"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Tags applied to all resources for organization and cost tracking
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
