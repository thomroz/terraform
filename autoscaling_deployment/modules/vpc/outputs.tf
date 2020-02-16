output "nginx_vpc_id" {
  value = aws_vpc.nginx_vpc.id
}

output "nginx_private_sn_az_a_id" {
    value = aws_subnet.nginx_private_sn_az_a.id
}

output "nginx_private_sn_az_b_id" {
    value = aws_subnet.nginx_private_sn_az_b.id
}

output "nginx_public_sn_az_a_id" {
    value = aws_subnet.nginx_public_sn_az_a.id
}

output "nginx_public_sn_az_b_id" {
    value = aws_subnet.nginx_public_sn_az_b.id
}

output "nginx_private_sg_id"{
  value = aws_security_group.nginx_private_sg.id
}

output "nginx_public_sg_id"{
  value = aws_security_group.nginx_public_sg.id
}

output "nginx_bastion_sg_id"{
  value = aws_security_group.nginx_bastion_sg.id
}