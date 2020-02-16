resource aws_lb "nginx-app-lb" {
  name               = "nginx-app-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.nginx_public_sg_id]
  subnets         = [var.nginx_public_sn_az_a_id, var.nginx_public_sn_az_b_id]

  enable_deletion_protection = false

  tags = {
    Name = "nginx-app-lb"
  }
}

resource aws_lb_listener nginx_lb_listener {
  load_balancer_arn = aws_lb.nginx-app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-app-lb-tg.arn
  }
}

resource aws_lb_target_group "nginx-app-lb-tg" {
  name     = "nginx-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.nginx_vpc_id
}
