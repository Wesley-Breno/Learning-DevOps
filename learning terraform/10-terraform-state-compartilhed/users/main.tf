terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = ">= 2.46"
      }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user"
}

output "my_iam_user_complete_details" {
  value = aws_iam_user.my_iam_user
}
