#!/bin/bash

## This script tears down a simple EC2 instance and cleans up associated resources.

# Defaults (ensure these match the launch script)
KEY_NAME="default-key"
SECURITY_GROUP_NAME="default-sg-launch"
TAG_NAME="EC2-1"  # Fixed to match launch script

echo "🔍 Finding EC2 instance with tag Name=$TAG_NAME..."
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$TAG_NAME" "Name=instance-state-name,Values=running,pending,stopping,stopped" \
  --query "Reservations[0].Instances[0].InstanceId" \
  --output text 2>/dev/null)

if [[ "$INSTANCE_ID" == "None" || -z "$INSTANCE_ID" ]]; then
  echo "⚠️ No instance found with the tag name $TAG_NAME"
  
  # Try to find any instances created with the key pair as fallback
  echo "🔍 Searching for instances using key pair $KEY_NAME..."
  INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=key-name,Values=$KEY_NAME" "Name=instance-state-name,Values=running,pending,stopping,stopped" \
    --query "Reservations[0].Instances[0].InstanceId" \
    --output text 2>/dev/null)
  
  if [[ "$INSTANCE_ID" == "None" || -z "$INSTANCE_ID" ]]; then
    echo "⚠️ No instances found using key pair $KEY_NAME either"
  else
    echo "📍 Found instance $INSTANCE_ID using key pair $KEY_NAME"
  fi
fi

if [[ "$INSTANCE_ID" != "None" && -n "$INSTANCE_ID" ]]; then
  echo "🛑 Terminating instance: $INSTANCE_ID"
  aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" >/dev/null
  
  if [[ $? -eq 0 ]]; then
    echo "⏳ Waiting for instance to terminate..."
    aws ec2 wait instance-terminated --instance-ids "$INSTANCE_ID"
    echo "✅ Instance $INSTANCE_ID terminated successfully."
  else
    echo "❌ Failed to terminate instance $INSTANCE_ID"
  fi
else
  echo "ℹ️ No instances to terminate."
fi

# Delete security group (only if it's not the default and no instances are using it)
echo "🔍 Finding security group $SECURITY_GROUP_NAME..."
SG_ID=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=$SECURITY_GROUP_NAME" \
  --query "SecurityGroups[0].GroupId" \
  --output text 2>/dev/null)

if [[ "$SG_ID" == "None" || -z "$SG_ID" ]]; then
  echo "⚠️ Security group $SECURITY_GROUP_NAME not found."
else
  echo "🧹 Attempting to delete security group $SECURITY_GROUP_NAME ($SG_ID)..."
  
  # Wait a moment for AWS to process the instance termination
  sleep 10
  
  if aws ec2 delete-security-group --group-id "$SG_ID" 2>/dev/null; then
    echo "✅ Security group deleted successfully."
  else
    echo "⚠️ Could not delete security group (may still be in use or be the default security group)"
  fi
fi

# Delete key pair
echo "🗝️ Deleting key pair $KEY_NAME..."
if aws ec2 delete-key-pair --key-name "$KEY_NAME" 2>/dev/null; then
  echo "✅ Key pair $KEY_NAME deleted successfully."
else
  echo "⚠️ Key pair $KEY_NAME not found or could not be deleted."
fi

# Delete .pem file
if [[ -f "$KEY_NAME.pem" ]]; then
  echo "🧼 Removing local key file $KEY_NAME.pem..."
  rm -f "$KEY_NAME.pem"
  echo "✅ Local key file removed."
else
  echo "ℹ️ Local key file $KEY_NAME.pem not found."
fi

echo "🎉 Cleanup complete."