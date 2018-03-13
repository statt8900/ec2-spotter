
#Connect to instances
export name=fast-ai
export key_name=aws-key-$name

export ip_address=`aws ec2 describe-instances --filters Name=tag:Name,Values=$name-gpu-machine --filters Name=instance-state-name,Values=running --output text --query 'Reservations[*].Instances[0].PublicIpAddress'`
export instance_id=`aws ec2 describe-instances --filters Name=tag:Name,Values=$name-gpu-machine --filters Name=instance-state-name,Values=running --output text --query 'Reservations[*].Instances[0].InstanceId'`
if [ -z "$ip_address" ]
then
      echo "No running instances with Name=$name-gpu-machine"
      echo "Make sure to run start_spot.sh"
else
    echo IP Address of instance: $instance_id
    echo connecting to IP address: $ip_address
    #Connect to instance
    ssh -i ~/.ssh/aws-key-$name.pem ubuntu@$ip_address
fi
