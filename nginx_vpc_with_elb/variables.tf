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

variable "nginx_public_key"{
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxjY0GPC+VMxXdxS+qwuR7sAHC41WQulK7j3UVClsPmtYCrkdxMdHya8bYmk79522ffM6liQNieFoN8BB6NUoDth30XKPV5qwsD5kUEd0frIWn5SRXDlO5Rv4gAPx1BCDM7uKp+L79NOhTObuZMlR05CSdovjHkxTd2uBxROUQB48rSeesneIxahVfQueP7TkLTlDMDnacy7PTOAncOQHVjQguvrdkTHI+iTDi25XNl9zberU4q/qz40fmd/ME7uFKCOGpseI59bwyhuCFr87vsC0keHQutx/JPra34ZqvNPOBUXKfRsxa6kNbfjt1oZIchJy6pp9KDswdvP/TGkpZ thomas@macbookpro.local"
}

