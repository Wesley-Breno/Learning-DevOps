terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.46"
    }
  }
}

variable "aws_key_pair" {
  default = "ec2.pem"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = "vpc-123"
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

resource "aws_instance" "http_server" {
  ami                    = "ami-123"
  key_name               = "ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = "subnet-123"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo service httpd start",
      "echo Hello World, DNS: ${self.public_dns} | sudo tee /var/www/html/index.html"
    ]
  }
}

output "my_security_group_http_server_details" {
  value = aws_security_group.http_server_sg
}

output "http_server_public_dns" {
    value = aws_instance.http_server.public_dns
}
