
# -----------------------------------------------------------------------------
# Static Website Infrastructure Resources
#
# This file provisions all AWS resources required to host a static website:
#   - An S3 bucket to store website files
#   - Security configuration to keep the bucket private
#   - Website objects (index and error pages)
#   - Website hosting configuration on the bucket
#   - Bucket policy allowing only CloudFront access
#   - CloudFront origin access control and distribution
# All taggable resources use the same `project` tag so they can be filtered
# together in the AWS console.
# -----------------------------------------------------------------------------

# S3 bucket that stores static website content (kept private and fronted by CloudFront).
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    project = "static-website-demo"
  }
}

# Block all forms of public access to the S3 bucket (CloudFront will be the public entry point).
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload the main index page for the website into the bucket.
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Upload a custom error page to be served for 4xx errors.
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
}

# Configure the S3 bucket as a static website endpoint (used by CloudFront).
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Bucket policy to allow only CloudFront (via the distribution's ARN) to read objects.
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.public_access]
}

# CloudFront Origin Access Control (OAC) used to securely access the S3 bucket.
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.bucket_name}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution that serves the static website over HTTPS.
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  default_root_object = "index.html"
  comment             = "CloudFront CDN for ${var.bucket_name}"

  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Custom error responses so users see a friendly error page instead of raw S3/CloudFront errors.
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/error.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/error.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    project = "static-website-demo"
  }

  depends_on = [aws_s3_bucket_public_access_block.public_access]
}