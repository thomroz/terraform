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

resource "aws_route_table" "nginx_public_rt" {
  vpc_id = aws_vpc.nginx_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx_public_gw.id
  }

  tags = {
    Name = "nginx_public_rt"
  }
}

resource "aws_route_table_association" "nginx_rt_assoc_public_a" {
  subnet_id      = aws_subnet.nginx_public_sn_az_a.id
  route_table_id = aws_route_table.nginx_public_rt.id
}

resource "aws_route_table_association" "nginx_rt_assoc_public_b" {
  subnet_id      = aws_subnet.nginx_public_sn_az_b.id
  route_table_id = aws_route_table.nginx_public_rt.id
}


resource "aws_route_table" "nginx_private_rt_a" {
  vpc_id = aws_vpc.nginx_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nginx_nat_gw_a.id
  }

  tags = {
    Name = "nginx_private_rt_a"
  }
}

resource "aws_route_table" "nginx_private_rt_b" {
  vpc_id = aws_vpc.nginx_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nginx_nat_gw_b.id
  }

  tags = {
    Name = "nginx_private_rt_b"
  }
}

resource "aws_key_pair" "nginx_keypair" {
  key_name   = "nginx_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAjAj/bKBh7Kyb5e24kRuAmvKG0wIHZWC+aCXn7McDazIQfcHH0VDzg/te2B7r2JCwZysjq2PLvrJWxYJ2eL8DKIzTNedbVK5FlkQBwBSgvtfKYzqfKGCt83wJLPTkKOJp9ss6ocaPG4DRZmYoKTUTMVynhguuGJ6LtqAdzGbvCVpLj7tw49xbC3ybobANoHlv/4Y/vsh+VqA/2KBHhM/MVBzbX4kJ1nt3vwkLdB/QtrQcZtdsZ7Rs4WYwKyZeB/3JgOQnqn8RFXDzscFy06bpGSUuoYPu6r4f5TZVCN+ggu7smyysyAaFxuKnzT3flLYMrJJe5MimCYUZOAkubn83 thomas@macbookpro.local"

  tags = {
    Name = "nginx_keypair"
  }
}

resource "aws_instance" "nginx_public_instance_a" {
  ami                    = "ami-04590e7389a6e577c"
  instance_type          = "t2.micro"
  key_name               = "nginx_key"
  subnet_id              = aws_subnet.nginx_public_sn_az_a.id
  vpc_security_group_ids = [aws_security_group.nginx_public_sg.id]

  tags = {
    Name = "nginx_public_instance_a"
  }
}

resource "aws_instance" "nginx_public_instance_b" {
  ami                    = "ami-04590e7389a6e577c"
  instance_type          = "t2.micro"
  key_name               = "nginx_key"
  subnet_id              = aws_subnet.nginx_public_sn_az_b.id
  vpc_security_group_ids = [aws_security_group.nginx_public_sg.id]

  tags = {
    Name = "nginx_public_instance_b"
  }
}







