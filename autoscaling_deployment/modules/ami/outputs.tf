output "nginx_ami_id" {
  value = aws_ami_from_instance.nginx_ami.id
}