resource "aws_key_pair" "nginx_init_keypair" {
  key_name   = "nginx_init_keypair"
  public_key = var.nginx_public_key

  tags = {
    Name = "nginx_init_keypair"
  }
}

resource "aws_instance" "nginx_init_instance" {
  ami           = "ami-04590e7389a6e577c"
  instance_type = var.nginx_instance_type

  key_name = "nginx_init_keypair"

  user_data = file(${path.module}/scripts/install_nginx.sh")

  tags = {
    Name = "nginx_init_instance"
  }
}

resource "aws_ami_from_instance" "nginx_ami" {
  name               = "nginx_ami"
  source_instance_id = aws_instance.nginx_init_instance.id
}


