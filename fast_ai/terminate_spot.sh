# settings
export name="fast-ai"
export keyName="aws-key-$name"
export maxPricePerHour=0.5

# Set current dir to working dir - http://stackoverflow.com/a/10348989/277871
cd "$(dirname ${BASH_SOURCE[0]})"

# By default it's empty
instance_id=
# Read the input args
while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    --instance_id)
    instance_id="$2"
    shift # pass argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # pass argument or value
done

# Find the instance id by the instance name (if there are two instances with same name, use the first one)
if [ "x$instance_id" = "x" ]
then
	# Get the instance by name.
	export instanceId=`aws ec2 describe-instances --filters Name=tag:Name,Values=$name-gpu-machine --filters Name=instance-state-name,Values=running --output text --query 'Reservations[*].Instances[0].InstanceId'`
else
	# We have passed an instance id
	instanceId=$instance_id
fi

# Terminate the on-demand instance
aws ec2 terminate-instances --instance-ids $instanceId
