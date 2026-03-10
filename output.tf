# -----------------------------------------------------------------------------
# Outputs for Static Website Hosting
#
# These outputs provide key information after deployment so you can quickly
# access the website and manage the CloudFront distribution and S3 bucket.
# -----------------------------------------------------------------------------

# HTTPS URL of the CloudFront distribution serving the static website.
output "website_endpoint" {
  description = "CloudFront HTTPS website URL"
  value       = "https://${aws_cloudfront_distribution.website.domain_name}"
}

# CloudFront distribution ID, useful when invalidating the cache after updates.
output "aws_cloudfront_distribution_id" {
  description = "CloudFront distribution ID - use this to invalidate cache after file updates"
  value       = aws_cloudfront_distribution.website.id
}

# Name of the S3 bucket that stores the static website files.
output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.website_bucket.bucket
}