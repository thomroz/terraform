resource "aws_key_pair" "nginx_keypair" {
  key_name   = "nginx_keypair"
  public_key = var.nginx_public_key

  tags = {
    Name = "nginx_keypair"
  }
}

resource "aws_instance" "nginx_bastion" {
  ami                         = var.nginx_ami_id
  instance_type               = var.nginx_instance_type
  key_name                    = "nginx_keypair"
  subnet_id                   = var.nginx_public_sn_az_a_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.nginx_bastion_sg_id]

  tags = {
    Name = "nginx_bastion"
  }
}
