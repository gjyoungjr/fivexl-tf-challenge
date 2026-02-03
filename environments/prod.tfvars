# environments/prod.tfvars
# Production environment configuration

environment  = "prod"
aws_region   = "us-east-1"
project_name = "fivexl-challenge"

tags = {
  CostCenter = "production"
}
