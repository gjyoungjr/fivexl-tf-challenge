# Main configuration file - provider setup and local values

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  # Default tags applied to ALL resources created by this provider
  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "terraform"
      },
      var.tags
    )
  }
}

# Local values for computed/derived values used across resources
locals {
  # Naming convention: project-environment (e.g., fivexl-challenge-dev)
  name_prefix = "${var.project_name}-${var.environment}"
}
