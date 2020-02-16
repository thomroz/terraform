provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}

module "asg" {
  source = "./modules/asg"

  nginx_ami_id             = var.nginx_ami_id
  nginx_instance_type      = var.nginx_instance_type
  nginx_private_sg_id      = module.vpc.nginx_private_sg_id
  nginx_private_sn_az_a_id = module.vpc.nginx_private_sn_az_a_id
  nginx_private_sn_az_b_id = module.vpc.nginx_private_sn_az_b_id
  nginx_app_lb_tg_arn      = module.elb.nginx_app_lb_tg_arn
}

module "cw" {
  source = "./modules/cw"

  nginx_private_asg_name                    = module.asg.nginx_private_asg_name
  nginx_private_asg_scaling_policy_up_arn   = module.asg.nginx_private_asg_scaling_policy_up_arn
  nginx_private_asg_scaling_policy_down_arn = module.asg.nginx_private_asg_scaling_policy_down_arn
}

module "ec2" {
  source = "./modules/ec2"

  nginx_ami_id            = var.nginx_ami_id
  nginx_instance_type     = var.nginx_instance_type
  nginx_public_key        = var.nginx_public_key
  nginx_bastion_sg_id     = module.vpc.nginx_bastion_sg_id
  nginx_public_sn_az_a_id = module.vpc.nginx_public_sn_az_a_id
}

module "elb" {
  source = "./modules/elb"

  nginx_vpc_id = module.vpc.nginx_vpc_id
  #nginx_private_sn_az_a_id = module.vpc.nginx_private_sn_az_a_id
  #nginx_private_sn_az_b_id = module.vpc.nginx_private_sn_az_b_id
  nginx_public_sn_az_a_id = module.vpc.nginx_public_sn_az_a_id
  nginx_public_sn_az_b_id = module.vpc.nginx_public_sn_az_b_id
  nginx_public_sg_id      = module.vpc.nginx_public_sg_id
}

module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source = "./modules/s3"
}
module "sns" {
  source = "./modules/sns"

  nginx_private_asg_name        = module.asg.nginx_private_asg_name
  nginx_asg_event_sms_recipient = "+17608186275"
}

module "vpc" {
  source = "./modules/vpc"
}
