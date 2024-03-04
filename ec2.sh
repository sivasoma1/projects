#!/bin/bash

NAME=("mongodb" "cart" "redis" "catalogue" "user" "payment" "dispatch" "web" "shipping" "mysql" "redis")
INSTANCE_TYPE=""
SECURITY_GROUP_ID=sg-012b40d35bddf900e
DOMAIN_NAME=ssshankar.site
IMAGE_ID=ami-0f3c7d07486cad139
HOSTED_ZONE_ID=Z07242593H082AXGG73OV

# Loop through the instances
for i in "${NAME[@]}"; do
    # Check if the instance already exists
    existing_instance=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$i" | jq -r '.Instances[0].PrivateIpAddress')
    if [ -n "$existing_instance" ]; then
        echo "$i instance already exists: $existing_instance"
        continue
    fi

    # Determine instance type
    if [ "$i" == "mysql" ] || [ "$i" == "mongodb" ]; then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    # Create EC2 instance
    echo "Creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo "Created $i instance: $IP_ADDRESS"

    # Update or create Route 53 record
    aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch '{
        "Changes": [{
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "'$i.$DOMAIN_NAME'",
                "Type": "A",
                "TTL": 300,
                "ResourceRecords": [{ "Value": "'$IP_ADDRESS'" }]
            }
        }]
    }'
done
