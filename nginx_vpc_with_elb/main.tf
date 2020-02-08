provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}


resource "aws_vpc" "nginx_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "nginx_vpc"
  }
}

resource "aws_subnet" "nginx_public_sn_az_a" {
  vpc_id                  = aws_vpc.nginx_vpc.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "nginx_public_sn_az_a"
  }
}

resource "aws_subnet" "nginx_public_sn_az_b" {
  vpc_id                  = aws_vpc.nginx_vpc.id
  cidr_block              = "172.16.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "nginx_public_sn_az_b"
  }
}

resource "aws_subnet" "nginx_private_sn_az_a" {
  vpc_id            = aws_vpc.nginx_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "nginx_private_sn_az_a"
  }
}

resource "aws_subnet" "nginx_private_sn_az_b" {
  vpc_id            = aws_vpc.nginx_vpc.id
  cidr_block        = "172.16.20.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "nginx_private_sn_az_b"
  }
}

resource "aws_security_group" "nginx_public_sg" {
  name        = "nginx_public_sg"
  description = "allow http, icmp, ssh"
  vpc_id      = aws_vpc.nginx_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["76.93.151.189/32"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["76.93.151.189/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.93.151.189/32"]
  }
}

resource "aws_security_group" "nginx_private_sg" {
  name        = "nginx_private_sg"
  description = "allow http, icmp, ssh"
  vpc_id      = aws_vpc.nginx_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.nginx_public_sn_az_a.cidr_block, aws_subnet.nginx_public_sn_az_b.cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_subnet.nginx_public_sn_az_a.cidr_block, aws_subnet.nginx_public_sn_az_b.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.nginx_public_sn_az_a.cidr_block, aws_subnet.nginx_public_sn_az_b.cidr_block]
  }
}

resource "aws_internet_gateway" "nginx_public_gw" {
  vpc_id = aws_vpc.nginx_vpc.id

  tags = {
    Name = "nginx_public_gw"
  }
}

resource aws_eip "nginx_nat_gw_eip_a" {
}

resource aws_eip "nginx_nat_gw_eip_b" {
}

resource "aws_nat_gateway" "nginx_nat_gw_a" {
  allocation_id = aws_eip.nginx_nat_gw_eip_a.id
  subnet_id     = aws_subnet.nginx_public_sn_az_a.id

  tags = {
    Name = "nginx_nat_gw_a"
  }
}

resource "aws_nat_gateway" "nginx_nat_gw_b" {
  allocation_id = aws_eip.nginx_nat_gw_eip_b.id
  subnet_id     = aws_subnet.nginx_public_sn_az_b.id

  tags = {
    Name = "nginx_nat_gw_b"
  }
}






