provider "aws" {
  region = "us-west-2"
}

# create a keypair resource
resource "aws_key_pair" "tfkey" {
  key_name   = "tfkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDYHdldcpQXANcd+4mbuLaz5LR/ZXPWWPLGqV5bqAWYrxaAiEa/gbKq3YzzPIEmlknIAz9Kjxrn4MkZn3PhaiL54LorYZbLLTB6wwUHRqTEg7v1qxR3CqfQsWDJdnYLPt1482oZ1uALfogea/9g07ElaAHauENYkzm/kyFWdXsSJUDnGHrCWngrp88GkH2fcKcabPH98DJmww32CZps2javPoWNRVTCT/hMwQGtOSO6B+YvbwBZCW3D6lujTo56hChxlnDHf9tjwfSGkww6X8c8kbUys8U4wh1YF94PUHn47BM3299p2TbQEx7Z+0dgWQ8ZJZVXBvFKbNhU47wo5RgL thomas@macair.local"
}

# create an EIP to attach to the new EC2 instance
resource "aws_eip" "tfeip" {
  instance = aws_instance.tfexample.id
  vpc      = true
}

# # get info about the atssrv.com zone as a data object
# data "aws_route53_zone" "selected" {
#   name = "atssrv.com."
# }

# # create an A-record and attach it to our EIP
# resource "aws_route53_record" "a_record" {
#   zone_id = "${data.aws_route53_zone.selected.zone_id}"
#   name    = "${data.aws_route53_zone.selected.name}"
#   type    = "A"
#   ttl     = "300"

#   records = ["${aws_eip.tfeip.public_ip}"]
# }

# # create a CNAME record and attach it to our EIP
# resource "aws_route53_record" "cname_record" {
#   zone_id = "${data.aws_route53_zone.selected.zone_id}"
#   name    = "www.${data.aws_route53_zone.selected.name}"
#   type    = "CNAME"
#   ttl     = "300"

#   records = ["atssrv.com"]
# }

# create a security group that allows SSH traffic inbound so we can connect to our EC2 instance
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["76.93.151.0/24"]
  }
}

# create the EC2 instance
resource "aws_instance" "tfexample" {
  ami           = "ami-03ff314b1a9dacaa5"
  instance_type = "t2.micro"

  key_name        = "tfkey"
  security_groups = ["allow_ssh", "allow_postgres"]

  tags = {
    Name = "atssrv-tf-instance"
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
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "11.5"
  instance_class       = "db.t2.micro"
  name                 = "thomasdb"
  username             = "thomas"
  password             = "thomas123"
  parameter_group_name = "default.postgres11"
  apply_immediately    = "true"
  publicly_accessible  = "true"
  skip_final_snapshot  = "true"
}
