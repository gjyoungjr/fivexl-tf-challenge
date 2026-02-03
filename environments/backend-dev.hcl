# Backend configuration for dev environment
# Used with: terraform init -backend-config=environments/backend-dev.hcl

bucket = "fivexl-challenge-dev-terraform-state"
key    = "terraform.tfstate"
region = "us-east-1"
