provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}


resource "aws_vpc" "nginx_vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "nginx_public_sn_az_a" {
  vpc_id     = aws_vpc.nginx_vpc.id
  cidr_block = "172.16.1.0/24"

  tags = {
    Name = "nginx_public_sn_az_a"
  }
}

resource "aws_subnet" "nginx_public_sn_az_b" {
  vpc_id     = aws_vpc.nginx_vpc.id
  cidr_block = "172.16.0/24"

  tags = {
    Name = "nginx_public_sn_az_b"
  }
}

resource "aws_subnet" "nginx_private_sn_az_a" {
  vpc_id     = aws_vpc.nginx_vpc.id
  cidr_block = "172.16.0/24"

  tags = {
    Name = "nginx_private_sn_az_a"
  }
}

resource "aws_subnet" "nginx_private_sn_az_b" {
  vpc_id     = aws_vpc.nginx_vpc.id
  cidr_block = "172.16.0/24"

  tags = {
    Name = "nginx_private_sn_az_b"
  }
}


