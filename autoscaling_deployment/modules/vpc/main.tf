resource "aws_vpc" "nginx_vpc" {
  cidr_block = var.nginx_vpc_cidr

  tags = {
    Name = "nginx_vpc"
  }
}

resource "aws_subnet" "nginx_public_sn_az_a" {
  vpc_id                  = aws_vpc.nginx_vpc.id
  cidr_block              = var.nginx_public_sn_cidr_az_a
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "nginx_public_sn_az_a"
  }
}

resource "aws_subnet" "nginx_public_sn_az_b" {
  vpc_id                  = aws_vpc.nginx_vpc.id
  cidr_block              = var.nginx_public_sn_cidr_az_b
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "nginx_public_sn_az_b"
  }
}

resource "aws_subnet" "nginx_private_sn_az_a" {
  vpc_id            = aws_vpc.nginx_vpc.id
  cidr_block        = var.nginx_private_sn_cidr_az_a
  availability_zone = "us-west-2a"

  tags = {
    Name = "nginx_private_sn_az_a"
  }
}

resource "aws_subnet" "nginx_private_sn_az_b" {
  vpc_id            = aws_vpc.nginx_vpc.id
  cidr_block        = var.nginx_private_sn_cidr_az_b
  availability_zone = "us-west-2b"

  tags = {
    Name = "nginx_private_sn_az_b"
  }
}

resource "aws_security_group" "nginx_public_sg" {
  name        = "nginx_public_sg"
  description = "allow http"
  vpc_id      = aws_vpc.nginx_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nginx_bastion_sg" {
  name        = "nginx_bastion_sg"
  description = "allow ssh"
  vpc_id      = aws_vpc.nginx_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nginx_private_sg" {
  name        = "nginx_private_sg"
  description = "allow http, icmp, ssh"
  vpc_id      = aws_vpc.nginx_vpc.id

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.nginx_bastion_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_bastion_sg.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_route_table_association" "nginx_rt_assoc_private_a" {
  subnet_id      = aws_subnet.nginx_private_sn_az_a.id
  route_table_id = aws_route_table.nginx_private_rt_a.id
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

resource "aws_route_table_association" "nginx_rt_assoc_private_b" {
  subnet_id      = aws_subnet.nginx_private_sn_az_b.id
  route_table_id = aws_route_table.nginx_private_rt_b.id
}
