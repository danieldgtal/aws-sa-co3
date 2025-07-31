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
SG_ID="sg-031d4dae079ace442"

# Validate required parameters first
if [[ -z "$SUBNET_ID" ]]; then
  echo "❌ Subnet ID is empty. Please set a valid subnet ID for VPC: $VPC_ID"
  exit 1
fi

if [[ -z "$SG_ID" ]]; then
  echo "❌ Security Group ID is empty. Please set a valid security group ID."
  exit 1
fi

# Define key file path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY_FILE="$SCRIPT_DIR/$KEY_NAME.pem"

# Create key pair if it doesn't exist
if ! aws ec2 describe-key-pairs --key-names "$KEY_NAME" >/dev/null 2>&1; then
  echo "🔑 Creating key pair $KEY_NAME..."
  aws ec2 create-key-pair --key-name "$KEY_NAME" --query "KeyMaterial" --output text > "$KEY_FILE"
  chmod 400 "$KEY_FILE"
  echo "🔑 Key saved to: $KEY_FILE"
else
  echo "🔑 Key pair $KEY_NAME already exists in AWS."
  if [[ -f "$KEY_FILE" ]]; then
    echo "🔑 Local key file found: $KEY_FILE"
  else
    echo "❌ WARNING: Key pair exists in AWS but local .pem file not found!"
    echo "   You need the private key file to SSH to the instance."
    echo "   Options:"
    echo "   1. Delete the AWS key pair and run script again: aws ec2 delete-key-pair --key-name $KEY_NAME"
    echo "   2. Use a different KEY_NAME in the script"
    echo "   3. Place your existing $KEY_NAME.pem file in: $SCRIPT_DIR/"
    read -p "   Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      echo "Exiting..."
      exit 1
    fi
  fi
fi

# Launch EC2 instance
echo "🚀 Launching EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --count 1 \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids "$SG_ID" \
  --associate-public-ip-address \
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