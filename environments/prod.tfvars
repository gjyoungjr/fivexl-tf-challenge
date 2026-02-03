# environments/prod.tfvars
# Production environment configuration

environment  = "prod"
aws_region   = "us-east-1"
project_name = "fivexl-challenge"

# Website hosting: "s3" for S3 static hosting, "ec2" for EC2 with nginx
hosting_type = "s3"

# EC2 settings (only used when hosting_type = "ec2")
# ec2_instance_type = "t3.small"     # Larger instance for prod
# ec2_key_name      = "prod-keypair"  # SSH key for EC2 access

tags = {
  CostCenter = "production"
}
