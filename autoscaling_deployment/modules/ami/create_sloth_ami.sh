#!/bin/bash

# clean up any existing resources from earlier runs
echo yes | terraform destroy

echo yes | terraform apply

# stop the nginx_init_instance.  Terraform would take out the AMI as well, so use CLI
aws ec2 describe-instances --filters "Name=tag:Name,Values=nginx_init_instance" "Name=instance-state-name,Values=running" \
    --query 'Reservations[].Instances[].InstanceId' --output text | xargs aws ec2 stop-instances --instance-ids

# delete the nginx_keypair; it is only useful for debugging any issues in the AMI
aws ec2 delete-key-pair --key-name nginx_init_keypair




