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

# Cria um usuario IAM chamado 'my_iam_user_abc'
resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_abc"
}
