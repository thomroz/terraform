output "nginx-app-lb_url" {
  value = "http://${aws_lb.nginx-app-lb.dns_name}"
}
