resource "aws_cloudwatch_metric_alarm" "nginx-private-asg-cpu-alarm-up" {
  alarm_name          = "nginx-private-asg-cpu-alarm-up"
  alarm_description   = "nginx-private-asg-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "33"
  dimensions = {
    "AutoScalingGroupName" = var.nginx_private_asg_name
  }
  actions_enabled = true
  alarm_actions   = [var.nginx_private_asg_scaling_policy_up_arn]
}

resource "aws_cloudwatch_metric_alarm" "nginx-private-asg-cpu-alarm-down" {
  alarm_name          = "nginx-private-asg-cpu-alarm-down"
  alarm_description   = "nginx-private-asg-cpu-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"
  dimensions = {
    "AutoScalingGroupName" = var.nginx_private_asg_name
  }
  actions_enabled = true
  alarm_actions   = [var.nginx_private_asg_scaling_policy_down_arn]
}
