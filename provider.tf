# -----------------------------------------------------------------------------
# AWS Provider Configuration
#
# This block configures the AWS provider and sets the region using the
# `aws_region` variable so deployments can be easily redirected to another
# AWS region without changing this file.
# -----------------------------------------------------------------------------
provider "aws" {
  region = var.aws_region
}