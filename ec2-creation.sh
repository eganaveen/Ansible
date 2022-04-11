#!/bin/bash
if [ -z "$1" ]; then
    echo -e "\e[31m*** Machine name is needed. ***\e[0m"
    exit 1
fi
COMPONENT=$1
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')

aws ec2 run-instances --image-id="${AMI_ID}" \
                      --instance-type=t2.micro \
                      --tag-specification "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
                      --instance-market-options MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}| jq

