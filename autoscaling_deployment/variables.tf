variable "nginx_ami_id" {
  type = string
  default = "ami-04590e7389a6e577c"
}

variable "nginx_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "nginx_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0zYBRYZcLD4Mq7TzzHKZgG5EaO1n+edHhbEons+q3iUcb4UaxN0pTI7kJJQIgls64kHQ1XmC/fw3jjKvcNYiHe7WqC7r8ISnEe0eMb+Y+wsoVcXJKo+HQtdC7B0dh41l4dIH7iYyI1I+P+xQq3g0tK2FMC9cWmZ2Nn6i8NTTvmHqceeMcbU2xlTMY7VlFZ7f/bpVv7F/eKY1fje/srTZbNyKJuYQNLMec+6xbS2gneDQzoIIHErmuP3Y3aJGJb7XGjpnjJUDnyhigm5Wbg3dCp5rZ8p37vVFhqpBVMrPPf9rEMM4DQuzrJoYApgjE0mMuDis+iP9M9NsYBJ0PHpgl thomas@macair.local"
}
