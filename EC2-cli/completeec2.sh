#!/bin/bash
# Get the default VPC
vpc_id=$(aws ec2 describe-vpcs --query 'Vpcs[?IsDefault].VpcId' --output text)
# Create a security group 
aws ec2 create-security-group --description "open 22 80 8080 port" --group-name "openfortomcat" --vpc-id  $vpc_id

# Store security group id into variable
sg_id=$(aws ec2 describe-security-groups --group-name "openfortomcat" --query "SecurityGroups[].GroupId" --output text)
# Opening the port for 22 80 8080
for port_number in 22 80 8080
do
   aws ec2 authorize-security-group-ingress --group-name "openfortomcat" --protocol tcp --port "$port_number" --cidr 0.0.0.0/0
done
# Get the Subnets
subnet_id=$(aws ec2 describe-subnets --filter "Name=vpc-id,Values=$vpc_id" --query "Subnets[0].SubnetId" --output text)
# Create a key pair and import-key-pair
# ssh-keygen -t rsa -C "my-key" -f ~/.ssh/my-key
aws ec2 import-key-pair --key-name "my-key" --public-key-material fileb://~/.ssh/my-key.pub
# Create an EC2 instance with the security group and key pair


# JMESPATH
# JMESPATH IS EXPRESION FOR QUERYING THE JSON FILES
# Create a security group to open 22 , 80 , 8080 port for communication



# To create security group first we need to know vpcs-ids
