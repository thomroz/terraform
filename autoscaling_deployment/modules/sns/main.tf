resource "aws_sns_topic" "nginx_private_asg_topic" {
  name = "nginx_private_asg_topic"
}

resource "aws_sns_topic_subscription" "nginx_private_asg_topic_subscription" {
  topic_arn = aws_sns_topic.nginx_private_asg_topic.arn
  protocol  = "sms"
  endpoint  = var.nginx_asg_event_sms_recipient
}

resource "aws_autoscaling_notification" "nginx_scaling_notifications" {
  group_names = [var.nginx_private_asg_name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.nginx_private_asg_topic.arn
}
