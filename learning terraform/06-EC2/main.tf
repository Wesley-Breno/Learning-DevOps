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

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = "vpc-000"
  ingress = [
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      from_port = 0
      to_port   = 0
      protocol  = -1
      cidr_blocks = [
        "0.0.0.0/0"
      ]
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    name = "http_server_sg"
  }
}
