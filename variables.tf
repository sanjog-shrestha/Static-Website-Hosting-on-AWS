variable "aws_region" {
    description = "AWS region" 
    default = "us-west-2"
}

variable "bucket_name" {
    description = "Unique S3 bucket name" 
    type = string 
}