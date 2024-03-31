# Define a criacao dos providers e suas versoes
terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = ">= 2.46"
      }
    }
}

# Define a regiao do provider 'aws' que criamos
provider "aws" {
    region = "us-east-1"
}

# Cria uma bucket no S3 da AWS chamado 'werlindo3'
resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "werlindo3"
}

# Adiciona o versionamento no bucket 'werlindo3'
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.my_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Cria um usuario IAM
resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_updated"
}
