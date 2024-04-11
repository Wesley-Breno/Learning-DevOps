terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.46"
    }
  }
}

variable "aws_key_pair" {
  default = "default-ec2.pem"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {

}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}


data "aws_ami" "aws-linux-2-latest" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

data "aws_ami_ids" "aws-linux-2-latest_ids" {
  owners = ["amazon"]
}

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id
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
  ami                    = data.aws_ami.aws-linux-2-latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = data.aws_subnets.default_subnets.ids[0]

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
