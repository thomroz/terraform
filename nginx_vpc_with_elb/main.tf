provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}


resource "aws_vpc" "nginx_vpc" {
  cidr_block = var.nginx_vpc_cidr

  tags = {
    Name = "nginx_vpc"
  }
}

resource "aws_subnet" "nginx_public_sn_az_a" {
  vpc_id                  = aws_vpc.nginx_vpc.id
  cidr_block              = var.nginx_public_sn_cidr_az_a
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "nginx_public_sn_az_a"
  }
}

resource "aws_subnet" "nginx_public_sn_az_b" {
  vpc_id                  = aws_vpc.nginx_vpc.id
  cidr_block              = var.nginx_public_sn_cidr_az_b
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "nginx_public_sn_az_b"
  }
}

resource "aws_subnet" "nginx_private_sn_az_a" {
  vpc_id            = aws_vpc.nginx_vpc.id
  cidr_block        = var.nginx_private_sn_cidr_az_a
  availability_zone = "us-west-2a"

  tags = {
    Name = "nginx_private_sn_az_a"
  }
}

resource "aws_subnet" "nginx_private_sn_az_b" {
  vpc_id            = aws_vpc.nginx_vpc.id
  cidr_block        = var.nginx_private_sn_cidr_az_b
  availability_zone = "us-west-2b"

  tags = {
    Name = "nginx_private_sn_az_b"
  }
}

resource "aws_security_group" "nginx_public_sg" {
  name        = "nginx_public_sg"
  description = "allow http, icmp, ssh"
  vpc_id      = aws_vpc.nginx_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.ingress_cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nginx_private_sg" {
  name        = "nginx_private_sg"
  description = "allow http, icmp, ssh"
  vpc_id      = aws_vpc.nginx_vpc.id

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [aws_subnet.nginx_public_sn_az_a.cidr_block, aws_subnet.nginx_public_sn_az_b.cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.nginx_public_sn_az_a.cidr_block, aws_subnet.nginx_public_sn_az_b.cidr_block]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "nginx_public_gw" {
  vpc_id = aws_vpc.nginx_vpc.id

  tags = {
    Name = "nginx_public_gw"
  }
}

resource aws_eip "nginx_nat_gw_eip_a" {
}

resource aws_eip "nginx_nat_gw_eip_b" {
}

resource "aws_nat_gateway" "nginx_nat_gw_a" {
  allocation_id = aws_eip.nginx_nat_gw_eip_a.id
  subnet_id     = aws_subnet.nginx_public_sn_az_a.id

  tags = {
    Name = "nginx_nat_gw_a"
  }
}

resource "aws_nat_gateway" "nginx_nat_gw_b" {
  allocation_id = aws_eip.nginx_nat_gw_eip_b.id
  subnet_id     = aws_subnet.nginx_public_sn_az_b.id

  tags = {
    Name = "nginx_nat_gw_b"
  }
}

resource "aws_route_table" "nginx_public_rt" {
  vpc_id = aws_vpc.nginx_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx_public_gw.id
  }

  tags = {
    Name = "nginx_public_rt"
  }
}

resource "aws_route_table_association" "nginx_rt_assoc_public_a" {
  subnet_id      = aws_subnet.nginx_public_sn_az_a.id
  route_table_id = aws_route_table.nginx_public_rt.id
}

resource "aws_route_table_association" "nginx_rt_assoc_public_b" {
  subnet_id      = aws_subnet.nginx_public_sn_az_b.id
  route_table_id = aws_route_table.nginx_public_rt.id
}

resource "aws_route_table" "nginx_private_rt_a" {
  vpc_id = aws_vpc.nginx_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nginx_nat_gw_a.id
  }

  tags = {
    Name = "nginx_private_rt_a"
  }
}

resource "aws_route_table_association" "nginx_rt_assoc_private_a" {
  subnet_id      = aws_subnet.nginx_private_sn_az_a.id
  route_table_id = aws_route_table.nginx_private_rt_a.id
}

resource "aws_route_table" "nginx_private_rt_b" {
  vpc_id = aws_vpc.nginx_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nginx_nat_gw_b.id
  }

  tags = {
    Name = "nginx_private_rt_b"
  }
}

resource "aws_route_table_association" "nginx_rt_assoc_private_b" {
  subnet_id      = aws_subnet.nginx_private_sn_az_b.id
  route_table_id = aws_route_table.nginx_private_rt_b.id
}

resource "aws_key_pair" "nginx_keypair" {
  key_name   = "nginx_key"
  public_key = var.nginx_public_key

  tags = {
    Name = "nginx_keypair"
  }
}

resource "aws_launch_template" "nginx_launch_template_private" {
  name_prefix            = "nginx_"
  image_id               = var.nginx_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_private_sg.id]
}

resource "aws_autoscaling_group" "nginx_private_asg" {
  name                = "nginx_private_asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.nginx_private_sn_az_a.id, aws_subnet.nginx_private_sn_az_b.id]
  target_group_arns   = [aws_lb_target_group.nginx-app-lb-tg.arn]

  launch_template {
    id      = aws_launch_template.nginx_launch_template_private.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "nginx_private_asg_scaling_policy_up" {
  name                   = "nginx_private_asg_scaling_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 90
  autoscaling_group_name = aws_autoscaling_group.nginx_private_asg.name
}

resource "aws_cloudwatch_metric_alarm" "nginx-private-asg-cpu-alarm-up" {
  alarm_name          = "nginx-private-asg-cpu-alarm-up"
  alarm_description   = "nginx-private-asg-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "33"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.nginx_private_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.nginx_private_asg_scaling_policy_up.arn]
}

resource "aws_autoscaling_policy" "nginx_private_asg_scaling_policy_down" {
  name                   = "nginx_private_asg_scaling_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 90
  autoscaling_group_name = aws_autoscaling_group.nginx_private_asg.name
}

resource "aws_cloudwatch_metric_alarm" "nginx-private-asg-cpu-alarm-down" {
  alarm_name          = "nginx-private-asg-cpu-alarm-down"
  alarm_description   = "nginx-private-asg-cpu-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.nginx_private_asg.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.nginx_private_asg_scaling_policy_down.arn]
}

resource "aws_launch_template" "nginx_launch_template_public" {
  name_prefix            = "nginx"
  image_id               = var.nginx_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_public_sg.id]
}

resource "aws_autoscaling_group" "nginx_public_asg" {
  name                = "nginx_public_asg"
  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = [aws_subnet.nginx_public_sn_az_a.id, aws_subnet.nginx_public_sn_az_b.id]
  target_group_arns   = [aws_lb_target_group.nginx-app-lb-tg.arn]

  launch_template {
    id      = aws_launch_template.nginx_launch_template_public.id
    version = "$Latest"
  }
}

resource aws_lb "nginx-app-lb" {
  name               = "nginx-app-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.nginx_public_sg.id]
  subnets         = [aws_subnet.nginx_public_sn_az_a.id, aws_subnet.nginx_public_sn_az_b.id]

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
  vpc_id   = aws_vpc.nginx_vpc.id
}


