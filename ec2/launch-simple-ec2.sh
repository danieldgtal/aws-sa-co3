#!/bin/bash

# 📜 aws-saa-co3/ec2/launch-simple-ec2.sh

# Get the latest Amazon Linux 2023 AMI dynamically
echo "🔍 Finding latest Amazon Linux 2023 AMI..."
AMI_ID=$(aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-*" \
          "Name=architecture,Values=x86_64" \
          "Name=virtualization-type,Values=hvm" \
          "Name=state,Values=available" \
  --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" \
  --output text)

if [[ -z "$AMI_ID" || "$AMI_ID" == "None" ]]; then
  echo "❌ Could not find latest Amazon Linux 2023 AMI. Using fallback..."
  AMI_ID="ami-0c02fb55956c7d316"  # Fallback to your original
fi

echo "📀 Using AMI: $AMI_ID"

# Set defaults
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

# Ensure SSH access is allowed in the security group
echo "🔒 Checking SSH access in security group..."
SSH_RULE_EXISTS=$(aws ec2 describe-security-groups --group-ids "$SG_ID" --query "SecurityGroups[0].IpPermissions[?FromPort==\`22\` && ToPort==\`22\`]" --output text)

if [[ -z "$SSH_RULE_EXISTS" ]]; then
  echo "🔓 Adding SSH rule to security group $SG_ID..."
  aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0
  echo "✅ SSH rule added to security group."
else
  echo "✅ SSH rule already exists in security group."
fi

# Save key to Downloads folder
KEY_FILE="$HOME/Downloads/$KEY_NAME.pem"

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
    echo "   3. Place your existing $KEY_NAME.pem file in: $HOME/Downloads/"
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
  --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":8,"VolumeType":"gp3","DeleteOnTermination":true}}]' \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" "ResourceType=volume,Tags=[{Key=Name,Value=$TAG_NAME-root}]" \
  --user-data '#!/bin/bash
yum update -y
systemctl enable sshd
systemctl start sshd
' \
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

# Wait for system status checks to pass (IMPORTANT!)
echo "⏳ Waiting for system status checks to pass..."
aws ec2 wait system-status-ok --instance-ids "$INSTANCE_ID"

echo "⏳ Waiting for instance status checks to pass..."
aws ec2 wait instance-status-ok --instance-ids "$INSTANCE_ID"

# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "✅ EC2 Instance is fully ready!"
echo "📍 Instance ID: $INSTANCE_ID"
echo "🌐 Public IP: $PUBLIC_IP"
echo "🔑 Key file: $KEY_FILE"
echo ""
echo "🔌 Connect using:"
echo "ssh -i \"$KEY_FILE\" ec2-user@$PUBLIC_IP"
echo ""
echo "⏰ Waiting additional 30 seconds for SSH daemon to be fully ready..."
sleep 30
echo "✅ Ready to connect!"