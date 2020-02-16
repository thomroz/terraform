output "nginx_app_lb_url" {
  value = "http://${aws_lb.nginx-app-lb.dns_name}"
}

output "nginx_app_lb_tg_arn" {
  value = aws_lb_target_group.nginx-app-lb-tg.arn
}