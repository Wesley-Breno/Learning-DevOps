terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.46"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

// S3 encrypted 

resource "aws_s3_bucket" "enterprise_backend_state" {
  bucket = "dev-backend-state-of-terraforms-projects-werlindo"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.enterprise_backend_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.enterprise_backend_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// DynamoDB - locking

resource "aws_dynamodb_table" "enterprise_backend_lock" {
  name         = "dev-backend-lock-of-terraforms-projects-werlindo"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}