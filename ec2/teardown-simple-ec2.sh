#!/bin/bash

## This script tears down a simple EC2 instance and cleans up associated resources.

# Defaults (ensure these match the launch script)
KEY_NAME="default-key"
SECURITY_GROUP_NAME="default-sg-launch"
TAG_NAME="SimpleEC2Instance"

echo "🔍 Finding EC2 instance with tag Name=$TAG_NAME..."
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$TAG_NAME" "Name=instance-state-name,Values=running,pending,stopping,stopped" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text 2>/dev/null)

if [[ "$INSTANCE_ID" == "None" || -z "$INSTANCE_ID" ]]; then
  echo "⚠️ No instance found with the tag name $TAG_NAME"
else
  echo "🛑 Terminating instance: $INSTANCE_ID"
  aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" >/dev/null
  aws ec2 wait instance-terminated --instance-ids "$INSTANCE_ID"
  echo "✅ Instance terminated."
fi

# Delete security group
echo "🔍 Finding security group $SECURITY_GROUP_NAME..."
SG_ID=$(aws ec2 describe-security-groups \
  --group-names "$SECURITY_GROUP_NAME" \
  --query "SecurityGroups[0].GroupId" \
  --output text 2>/dev/null)

if [[ "$SG_ID" == "None" || -z "$SG_ID" ]]; then
  echo "⚠️ Security group $SECURITY_GROUP_NAME not found."
else
  echo "🧹 Deleting security group $SECURITY_GROUP_NAME..."
  aws ec2 delete-security-group --group-id "$SG_ID"
  echo "✅ Security group deleted."
fi

# Delete key pair
echo "🗝️ Deleting key pair $KEY_NAME..."
aws ec2 delete-key-pair --key-name "$KEY_NAME"

# Delete .pem file
if [[ -f "$KEY_NAME.pem" ]]; then
  echo "🧼 Removing local key file $KEY_NAME.pem..."
  rm -f "$KEY_NAME.pem"
fi

echo "🎉 Cleanup complete."
