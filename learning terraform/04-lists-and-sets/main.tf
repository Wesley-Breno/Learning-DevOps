terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.46"
    }
  }
}

variable "names" {
  default = ["ravs", "sats", "ranga"]
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my_iam_users" {
  for_each = toset(var.names)
  name = each.value
}
