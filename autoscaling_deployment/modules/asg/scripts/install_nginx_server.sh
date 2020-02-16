#! /bin/bash

sudo yum -y update
sudo amazon-linux-extras install -y epel nginx1.12
sudo yum -y install htop stress
sudo systemctl enable nginx
sudo systemctl start nginx
echo "<h1 align='center'>nginx Rocket Initial Website</h1>" | sudo tee /usr/share/nginx/html/index.html

# install code deploy agent
yum install -y ruby
cd /home/ec2-user
curl -O https://aws-codedeploy-us-west-2.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
