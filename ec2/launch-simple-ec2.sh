#!/bin/bash

## This script launches a simple EC2 instance on AWS with default configurations.
# It creates a key pair and security group if they do not exist, and then launches the instance.
# This script is intended for use in a bash environment with AWS CLI configured or AWS cloudshell.
# ## 📜 `aws-saa-co3/ec2/launch-simple-ec2.sh`


# Set defaults
AMI_ID="ami-0c02fb55956c7d316"    # Amazon Linux 2 (us-east-1)
INSTANCE_TYPE="t2.micro"
KEY_NAME="default-key"
SECURITY_GROUP_NAME="default-sg-launch"
TAG_NAME="EC2-1"

# Create key pair if it doesn't exist
if ! aws ec2 describe-key-pairs --key-names "$KEY_NAME" >/dev/null 2>&1; then
  echo "Creating key pair $KEY_NAME..."
  aws ec2 create-key-pair --key-name "$KEY_NAME" --query "KeyMaterial" --output text > "$KEY_NAME.pem"
  chmod 400 "$KEY_NAME.pem"
fi

# Create security group if it doesn't exist
VPC_ID=vpc-02c946c5dba80afbb

if ! aws ec2 describe-security-groups --group-names "$SECURITY_GROUP_NAME" >/dev/null 2>&1; then
  echo "Creating security group $SECURITY_GROUP_NAME..."
  SG_ID=$(aws ec2 create-security-group \
    --group-name "$SECURITY_GROUP_NAME" \
    --description "Default SG for EC2 launch script" \
    --vpc-id "$VPC_ID" \
    --query "GroupId" --output text)

  aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp --port 22 --cidr 0.0.0.0/0
else
  SG_ID=$(aws ec2 describe-security-groups \
    --group-names "$SECURITY_GROUP_NAME" \
    --query "SecurityGroups[0].GroupId" \
    --output text)
fi

# Launch EC2 instance
echo "Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --count 1 \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SG_ID" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
  --query "Instances[0].InstanceId" \
  --output text)

echo "Instance launched with ID: $INSTANCE_ID"

# Optional: Wait for running state and get public IP
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "✅ EC2 Instance is running. Public IP: $PUBLIC_IP"
