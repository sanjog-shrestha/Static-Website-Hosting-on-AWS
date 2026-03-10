# -----------------------------------------------------------------------------
# Input Variables for Static Website Hosting
#
# These variables allow you to control the deployment region and the S3 bucket
# name used for the static website.
# -----------------------------------------------------------------------------

# AWS region in which to create all resources (e.g., eu-west-2).
variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-2"
}

# Globally-unique S3 bucket name that will host the static website content.
variable "bucket_name" {
  description = "Unique S3 bucket name"
  type        = string
}