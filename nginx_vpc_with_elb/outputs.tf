output "nginx_app_lb_url" {
  value = "http://${aws_lb.nginx-app-lb.dns_name}"
}

output "nginx_asg_event_sms_recipient" {
  value = var.nginx_asg_event_sms_recipient
}
