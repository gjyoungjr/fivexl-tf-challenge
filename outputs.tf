# outputs.tf
# Output values shown after terraform apply
# We'll add more outputs as we create resources

output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "name_prefix" {
  description = "Resource naming prefix"
  value       = local.name_prefix
}

# State bucket outputs
output "terraform_state_bucket" {
  description = "S3 bucket for Terraform state storage"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "terraform_state_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state storage"
  value       = aws_s3_bucket.terraform_state.arn
}

output "terraform_locks_table" {
  description = "DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

# Website outputs
output "hosting_type" {
  description = "Current hosting type (s3 or ec2)"
  value       = var.hosting_type
}

output "website_url" {
  description = "URL of the static website"
  value = var.hosting_type == "s3" ? (
    length(aws_s3_bucket_website_configuration.website) > 0 ? "http://${aws_s3_bucket_website_configuration.website[0].website_endpoint}" : null
    ) : (
    length(aws_eip.web) > 0 ? "http://${aws_eip.web[0].public_ip}" : null
  )
}

# EC2-specific outputs (only populated when hosting_type = "ec2")
output "ec2_instance_id" {
  description = "EC2 instance ID (only when hosting_type = 'ec2')"
  value       = length(aws_instance.web) > 0 ? aws_instance.web[0].id : null
}

output "ec2_public_ip" {
  description = "EC2 Elastic IP address - stable across redeployments (only when hosting_type = 'ec2')"
  value       = length(aws_eip.web) > 0 ? aws_eip.web[0].public_ip : null
}

# S3-specific outputs (only populated when hosting_type = "s3")
output "website_bucket" {
  description = "S3 bucket name (only when hosting_type = 's3')"
  value       = length(aws_s3_bucket.website) > 0 ? aws_s3_bucket.website[0].bucket : null
}
