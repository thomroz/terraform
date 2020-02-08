variable "nginx_vpc_cidr" {
  type    = string
  default = "172.10.0.0/16"
}

variable "nginx_public_sn_cidr_az_a" {
  type    = string
  default = "172.10.1.0/24"
}

variable "nginx_public_sn_cidr_az_b" {
  type    = string
  default = "172.10.2.0/24"
}

variable "nginx_private_sn_cidr_az_a" {
  type    = string
  default = "172.10.10.0/24"
}

variable "nginx_private_sn_cidr_az_b" {
  type    = string
  default = "172.10.20.0/24"
}

