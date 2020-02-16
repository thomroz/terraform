resource "aws_launch_template" "nginx_launch_template_private" {
  name_prefix            = "nginx_private"
  image_id               = var.nginx_ami_id
  instance_type          = var.nginx_instance_type
  key_name               = "nginx_keypair"
  vpc_security_group_ids = [var.nginx_private_sg_id]
  user_data              = filebase64("${path.module}/scripts/install_nginx_server.sh")

  iam_instance_profile {
    name = "CodeDeploy-EC2-Instance-Profile"
  }

  tag_specifications {
    resource_type = "instance"

    tags = map(
      "Name", "nginx_nginx_private_instance",
    )
  }
}

resource "aws_autoscaling_group" "nginx_private_asg" {
  name                = "nginx_private_asg"
  min_size            = var.nginx_asg_min_size
  max_size            = var.nginx_asg_max_size
  desired_capacity    = var.nginx_asg_desired_capacity
  vpc_zone_identifier = [var.nginx_private_sn_az_a_id, var.nginx_private_sn_az_b_id]
  target_group_arns   = [var.nginx_app_lb_tg_arn]

  launch_template {
    id      = aws_launch_template.nginx_launch_template_private.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "nginx_private_asg_scaling_policy_up" {
  name                   = "nginx_private_asg_scaling_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.nginx_private_asg.name
}

resource "aws_autoscaling_policy" "nginx_private_asg_scaling_policy_down" {
  name                   = "nginx_private_asg_scaling_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.nginx_private_asg.name
}
