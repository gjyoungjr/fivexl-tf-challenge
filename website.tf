locals {
  use_s3 = var.hosting_type == "s3"
}

# S3 bucket for website
resource "aws_s3_bucket" "website" {
  count  = local.use_s3 ? 1 : 0
  bucket = "${local.name_prefix}-website"
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  count  = local.use_s3 ? 1 : 0
  bucket = aws_s3_bucket.website[0].id

  index_document {
    suffix = "index.html"
  }
}

# Allow public access (required for static website)
resource "aws_s3_bucket_public_access_block" "website" {
  count  = local.use_s3 ? 1 : 0
  bucket = aws_s3_bucket.website[0].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket policy for public read access
resource "aws_s3_bucket_policy" "website" {
  count  = local.use_s3 ? 1 : 0
  bucket = aws_s3_bucket.website[0].id

  # Ensure public access block is applied first
  depends_on = [aws_s3_bucket_public_access_block.website]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website[0].arn}/*"
      }
    ]
  })
}

# Upload index.html
resource "aws_s3_object" "index" {
  count        = local.use_s3 ? 1 : 0
  bucket       = aws_s3_bucket.website[0].id
  key          = "index.html"
  source       = "website/index.html"
  content_type = "text/html"
  etag         = filemd5("website/index.html")
}
