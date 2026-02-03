# Backend configuration for prod environment
# Used with: terraform init -backend-config=environments/backend-prod.hcl

bucket = "fivexl-challenge-prod-terraform-state"
key    = "terraform.tfstate"
region = "us-east-1"
