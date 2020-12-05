# get the default vpc-ids in your region
current_region="us-east-2"
ubuntu_20_amiid="ami-0a91cd140a1fc148a"
windows_2019_amiid="ami-056f139b85f494248"

echo "fetching the aws default vpc id"
# find default vpc id in your region
vpc_id=$(aws ec2 describe-vpcs --query "Vpcs[?IsDefault].VpcId" --output text)
echo "created the vpc with id ${vpc_id}"
# create a new security group 
sgroupname='openfortomcat'
echo "creating the security group with the name ${sgroupname}"

aws ec2 create-security-group --description "open port for 22 80 8080" --group-name "${sgroupname}" --vpc-id $vpc_id
# store security group id in some variable
sg_id=$(aws ec2 describe-security-groups --group-name "${sgroupname}" --query "SecurityGroups[0].GroupId" --output text)
echo "Created security group with id ${sg_id}"
# lets open port for this security group
for port_number in 22 80 8080
do
    echo "Creating a security group ingress rules for ${port_number}"
    aws ec2 authorize-security-group-ingress  --group-name "${sgroupname}" --protocol tcp --port "$port_number" --cidr 0.0.0.0/0
done

key_name="my-key"
# Get the key pair 
echo "importing key pair"
aws ec2 import-key-pair --key-name $key_name --public-key-material fileb://~/.ssh/my-key.pub
az_a="${current_region}a"
az_b="${current_region}b"
az_c="${current_region}c"

# create a subnets for your vpc
# subnet id in az -a
subnet_a=$(aws ec2 describe-subnets --filters "Name=availability-zone,Values=${az_a}" "Name=vpc-id,Values=$vpc_id" --query "Subnets[0].SubnetId" --output text)
echo "subnet in ${az_a}" is ${subnet_a}
# subnet id in az -b
subnet_b=$(aws ec2 describe-subnets --filters "Name=availability-zone,Values=${az_b}" "Name=vpc-id,Values=$vpc_id" --query "Subnets[0].SubnetId" --output text)
echo "subnet in ${az_b}" is ${subnet_b}
# subnet id in az -c
subnet_c=$(aws ec2 describe-subnets --filters "Name=availability-zone,Values=${az_c}" "Name=vpc-id,Values=$vpc_id" --query "Subnets[0].SubnetId" --output text)
echo "subnet in ${az_c}" is ${subnet_c}


default_instance_type="t2.micro"

aws ec2 run-instances --image-id $ubuntu_20_amiid --instance-type $default_instance_type --key-name $key_name --security-group-ids $sg_id --subnet-id $subnet_a --count 1

#for windows ami run the following commands
aws ec2 run-instances --image-id windows_2019_amiid --instance-type $default_instance_type --key-name $key_name --security-group-ids $sg_id --subnet-id $subnet_b --count 1