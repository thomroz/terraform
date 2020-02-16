output "nginx_private_asg_name"{
    value = aws_autoscaling_group.nginx_private_asg.name
}

output "nginx_private_asg_scaling_policy_up_arn"{
    value = aws_autoscaling_policy.nginx_private_asg_scaling_policy_up.arn
}

output "nginx_private_asg_scaling_policy_down_arn"{
    value = aws_autoscaling_policy.nginx_private_asg_scaling_policy_down.arn
}