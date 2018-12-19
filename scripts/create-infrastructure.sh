#!/bin/bash

image_id=ami-09693313102a30b2c
instance_type=t2.micro
vpc_id=vpc-04540e242cdfb35de
key_name=user10
security_group=...
subnet_id=subnet-0d00d8b5d01e66e35
shutdown_type=stop
tags="ResourceType=instance,Tags=[{Key=installation_id,Value=user10-1},{Key=Name,Value=user10-vm1}]"

start()
{
  private_ip_address="10.2.1.101"
  public_ip=associate-public-ip-address

  aws ec2 run-instances \
    --image-id "$image_id" \
    --instance-type "$instance_type" \
    --key-name "$key_name" \
    --subnet-id "$subnet_id" \
    --instance-initiated-shutdown-behavior "$shutdown_type" \
    --private-ip-address "$private_ip_address" \
    --tag-specifications "$tags" \
    --${public_ip} 

  # --security-groups "$security_group" \

  #  [--block-device-mappings <value>]
  #  [--placement <value>]
  #  [--user-data <value>]

}

stop()
{
  ids=($(
    aws ec2 describe-instances \
    --query 'Reservations[*].Instances[?KeyName==`'$key_name'`].InstanceId' \
    --output text
  ))
  aws ec2 terminate-instances --instance-ids "${ids[@]}"
}

if [ "$1" = start ]; then
  start
elif [ "$1" = stop ]; then
  stop
else
  cat <<EOF
Usage:

  $0 start|stop
EOF
  exit 1
fi
