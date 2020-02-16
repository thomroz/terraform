#! /bin/bash

sudo yum -y update
sudo amazon-linux-extras install -y epel nginx1.12
sudo yum -y install htop stress
sudo systemctl enable nginx
sudo systemctl start nginx
echo "<h1>nginx Rocket Nginx Instance</h1>" | sudo tee /usr/share/nginx/html/index.html
