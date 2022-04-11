#!/bin/bash
if [ -z "$1" ]; then
    echo "Machine name is needed."
    exit 1
fi
COMPONENT=$1
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')

aws ec2 run-instances --image-id="${AMI_ID}" --instance-type=t2.micro --tags-specification 'ResourceType=instance,Tags=[{key=Name,value=${COMPONENT}}]'

