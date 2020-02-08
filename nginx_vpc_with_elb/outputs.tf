output "nginx_public_instance_a_public_ip" {
  value = aws_instance.nginx_public_instance_a.public_ip
}

output "nginx_public_instance_b_public_ip" {
  value = aws_instance.nginx_public_instance_b.public_ip
}

output "nginx_private_instance_a_private_ip" {
  value = aws_instance.nginx_private_instance_a.private_ip
}

output "nginx_private_instance_b_private_ip" {
  value = aws_instance.nginx_private_instance_b.private_ip
}

output "nginx-app-lb_url" {
  value = "http://${aws_lb.nginx-app-lb.dns_name}"
}
