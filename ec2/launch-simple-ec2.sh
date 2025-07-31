#!/bin/bash

# 📜 aws-saa-co3/ec2/launch-simple-ec2.sh

# Set defaults
AMI_ID="ami-0c02fb55956c7d316"    # Amazon Linux 2 (us-east-1)
INSTANCE_TYPE="t2.micro"
KEY_NAME="default-key"
SECURITY_GROUP_NAME="default-sg-launch"
TAG_NAME="EC2-1"
VPC_ID="vpc-02c946c5dba80afbb"
SUBNET_ID="subnet-0e3975d7ac071471c"


# Create key pair if it doesn't exist
if ! aws ec2 describe-key-pairs --key-names "$KEY_NAME" >/dev/null 2>&1; then
  echo "🔑 Creating key pair $KEY_NAME..."
  aws ec2 create-key-pair --key-name "$KEY_NAME" --query "KeyMaterial" --output text > "$KEY_NAME.pem"
  chmod 400 "$KEY_NAME.pem"
else
  echo "🔑 Key pair $KEY_NAME already exists."
fi

# Check for existing security group by name and VPC
echo "🔐 Checking for existing security group..."
SG_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values="$SECURITY_GROUP_NAME" Name=vpc-id,Values="$VPC_ID" \
  --query "SecurityGroups[0].GroupId" \
  --output text 2>/dev/null)

# If not found, create it
if [[ "$SG_ID" == "None" || -z "$SG_ID" ]]; then
  echo "🔐 Creating new security group $SECURITY_GROUP_NAME..."
  SG_ID=$(aws ec2 create-security-group \
    --group-name "$SECURITY_GROUP_NAME" \
    --description "Default SG for EC2 launch script" \
    --vpc-id "$VPC_ID" \
    --query "GroupId" --output text)

  if [[ -z "$SG_ID" || "$SG_ID" == "None" ]]; then
    echo "❌ Failed to create security group. Exiting."
    exit 1
  fi

  # Add SSH access
  aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0
else
  echo "🔐 Using existing security group with ID: $SG_ID"
fi

# Double check SG_ID is not empty
if [[ -z "$SG_ID" ]]; then
  echo "❌ Security Group ID is empty. Exiting."
  exit 1
fi

# Launch EC2 instance
echo "🚀 Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --count 1 \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SG_ID" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
  --query "Instances[0].InstanceId" \
  --output text 2>/dev/null)

if [[ -z "$INSTANCE_ID" || "$INSTANCE_ID" == "None" ]]; then
  echo "❌ Failed to launch EC2 instance. Check security group and key name. Exiting."
  exit 1
fi

echo "✅ Instance launched with ID: $INSTANCE_ID"

# Wait for instance to be running
echo "⏳ Waiting for EC2 instance to enter 'running' state..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "✅ EC2 Instance is running. Public IP: $PUBLIC_IP"
