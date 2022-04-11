#!/bin/bash
if [ -z "$1" ]; then
    echo -e "\e[31m*** Machine name is needed. ***\e[0m"
    exit 1
fi
COMPONENT=$1
AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=sg_all | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')
ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[*].{name:Name,ID:Id}" \
                                        --output text | grep roboshop.internal | awk '{print $1}' | awk -F / '{print $3}')
PRIVATE_IP=(aws ec2 run-instances --image-id="${AMI_ID}" \
                      --instance-type=t2.micro \
                      --tag-specification "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
                      --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
                      --security-group-ids ${SGID} | jq .'Instances.PrivateIpAddress')

