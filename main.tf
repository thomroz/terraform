provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "tfkey" {
  key_name   = "tfkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf2qAiVLLwmrkWBhYp1ACp6tLE04diFwGSKoxPA2AcpK0CCTgq8QbJJFEAEgPtxclmFxYg6xs8mSNq8z13fXCG4v0zw+mq3F+QdZxGY4RoaGS+K7MCQ2FzvuNP27wDPwfBFhyrO2JGuG83kAQ+eShaRVabpgSJadW3Rx38D3ZkzwfG7rCgusUHu8XFgyTygvwed/Um2dyXpz0xSjk/0k/KF4v4aK0SCRXVjp/Rh+KgUmy82tnIzy8Vxie0hKl2uCK/Ssuq4VYgDjI97LUMzhrHtVNTWFVL8sjK5VWY0+TxPNbnfVXkP9vIIqTRZmcxJEbVaZu7XHMJGnQN9ZtnV+or thomas@m700"
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.tfexample.id}"
  vpc      = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.93.151.189/32"]
  }
}

resource "aws_instance" "tfexample" {
  ami           = "ami-0ad99772"
  instance_type = "t2.micro"

  key_name        = "tfkey"
  security_groups = ["allow_ssh"]

  tags {
    Name = "ats-terraform-example"
  }
}
