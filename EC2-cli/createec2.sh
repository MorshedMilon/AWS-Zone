#!/bin/bash

# In this I will try to create Ec2 Instances

aws ec2 run-instances --image-id "ami-0a91cd140a1fc148a" --instance-type "t2.micro" --security-group-ids "sg-0dc0799f240c36dbe" --key-name "ansible_key"

# To Remove ec2 instance make note of instance id

aws ec2 terminate-instances --instance-ids  "i-093039110718b97ee"
# example