variable nginx_ami_id {}
variable nginx_instance_type {}
variable nginx_private_sg_id {}
variable nginx_private_sn_az_a_id {}
variable nginx_private_sn_az_b_id {}
variable nginx_app_lb_tg_arn {}

variable "nginx_asg_min_size" {
  type    = number
  default = 2
}

variable "nginx_asg_max_size" {
  type    = number
  default = 4
}

variable "nginx_asg_desired_capacity" {
  type    = number
  default = 2
}