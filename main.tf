terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  
}
resource "aws_instance" "wordpress" {
  ami                    = "ami-0ddc798b3f1a5117e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true

  tags = {
    Name = "wordpress-instance"
  }
}