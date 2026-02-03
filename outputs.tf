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
