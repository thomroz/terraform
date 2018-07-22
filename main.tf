provider "aws" {
  region = "us-west-2"
}

# create a keypair resource
resource "aws_key_pair" "tfkey" {
  key_name   = "tfkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCf2qAiVLLwmrkWBhYp1ACp6tLE04diFwGSKoxPA2AcpK0CCTgq8QbJJFEAEgPtxclmFxYg6xs8mSNq8z13fXCG4v0zw+mq3F+QdZxGY4RoaGS+K7MCQ2FzvuNP27wDPwfBFhyrO2JGuG83kAQ+eShaRVabpgSJadW3Rx38D3ZkzwfG7rCgusUHu8XFgyTygvwed/Um2dyXpz0xSjk/0k/KF4v4aK0SCRXVjp/Rh+KgUmy82tnIzy8Vxie0hKl2uCK/Ssuq4VYgDjI97LUMzhrHtVNTWFVL8sjK5VWY0+TxPNbnfVXkP9vIIqTRZmcxJEbVaZu7XHMJGnQN9ZtnV+or thomas@m700"
}

# create an EIP to attach to the new EC2 instance
resource "aws_eip" "tfeip" {
  instance = "${aws_instance.tfexample.id}"
  vpc      = true
}

# get info about the atssrv.com zone as a data object
data "aws_route53_zone" "selected" {
  name = "atssrv.com."
}

# create an A-record and attach it to our EIP
resource "aws_route53_record" "a_record" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"

  records = ["${aws_eip.tfeip.public_ip}"]
}

# create a CNAME record and attach it to our EIP
resource "aws_route53_record" "cname_record" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "www.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "300"

  records = ["atssrv.com"]
}

# create a security group that allows SSH traffic inbound so we can connect to our EC2 instance
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

# create a security group that allows postgres traffic
resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres"
  description = "Allow postgres port"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["76.93.151.189/32"]
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "10.4"
  instance_class       = "db.t2.small"
  name                 = "postgres_db"
  username             = "thomas"
  password             = "thomas123"
  parameter_group_name = "default.postgres10"
}

# create the EC2 instance
resource "aws_instance" "tfexample" {
  ami           = "ami-0ad99772"
  instance_type = "t2.micro"

  key_name        = "tfkey"
  security_groups = ["allow_ssh", "allow_postgres"]

  tags {
    Name = "atssrv-tf-instance"
  }
}
