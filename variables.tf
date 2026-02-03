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

variable "hosting_type" {
  description = "Where to host the website: 's3' for S3 static hosting or 'ec2' for EC2 instance with nginx"
  type        = string
  default     = "s3"

  validation {
    condition     = contains(["s3", "ec2"], var.hosting_type)
    error_message = "hosting_type must be 's3' or 'ec2'"
  }
}

variable "ec2_instance_type" {
  description = "EC2 instance type for website hosting (only used when hosting_type = 'ec2')"
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "Name of the SSH key pair for EC2 access (only used when hosting_type = 'ec2')"
  type        = string
  default     = null
}

# Tags applied to all resources for organization and cost tracking
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
