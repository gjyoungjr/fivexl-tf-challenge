# ec2-website.tf
# EC2-based website hosting (conditional on hosting_type)

locals {
  use_ec2 = var.hosting_type == "ec2"

  # Read website content for user_data
  website_content = file("website/index.html")
}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  count       = local.use_ec2 ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get default VPC
data "aws_vpc" "default" {
  count   = local.use_ec2 ? 1 : 0
  default = true
}

# Security group for web traffic
resource "aws_security_group" "web" {
  count       = local.use_ec2 ? 1 : 0
  name        = "${local.name_prefix}-web-sg"
  description = "Allow HTTP and SSH traffic for website"
  vpc_id      = data.aws_vpc.default[0].id

  # HTTP access from anywhere
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access (optional, for debugging)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-web-sg"
  }
}

# EC2 instance running nginx
resource "aws_instance" "web" {
  count                       = local.use_ec2 ? 1 : 0
  ami                         = data.aws_ami.amazon_linux[0].id
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_name
  vpc_security_group_ids      = [aws_security_group.web[0].id]
  associate_public_ip_address = true

  # User data script to install nginx and deploy website
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e

    # Update system
    dnf update -y

    # Install nginx
    dnf install -y nginx

    # Enable and start nginx
    systemctl enable nginx
    systemctl start nginx

    # Deploy website content
    cat > /usr/share/nginx/html/index.html << 'WEBSITE'
    ${local.website_content}
    WEBSITE

    # Ensure nginx is running
    systemctl restart nginx
  EOF
  )

  tags = {
    Name = "${local.name_prefix}-web-server"
  }

  # Recreate instance if user_data changes (website content update)
  lifecycle {
    create_before_destroy = true
  }
}

# Elastic IP for stable endpoint (persists across instance replacements)
resource "aws_eip" "web" {
  count  = local.use_ec2 ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${local.name_prefix}-web-eip"
  }
}

# Associate EIP with EC2 instance
resource "aws_eip_association" "web" {
  count         = local.use_ec2 ? 1 : 0
  instance_id   = aws_instance.web[0].id
  allocation_id = aws_eip.web[0].id
}
