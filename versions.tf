terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Partial backend configuration - actual values passed via:
  #   terraform init -backend-config=environments/backend-<env>.hcl
  # This enables separate state files per environment/account
  backend "s3" {
    # bucket, key, region provided via -backend-config
    use_lockfile = true
    encrypt      = true
  }
}
