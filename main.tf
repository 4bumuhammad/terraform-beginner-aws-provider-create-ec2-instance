terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {

}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

resource "aws_instance" "public_intance" {
  ami           = "ami-06c4be2792f419b7b"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.key_pair.key_name

  tags = {
    Name = "public_instance"
  }
}

# AWS Region
# Singapore : ap-southeast-1

# AWS Launch an instance Ubuntu OS
# AMI ID : ami-06c4be2792f419b7b