#!/bin/bash
## Creates a custom security group in AWS with specified ingress and egress rules.
# ----------- CONFIGURABLE VARIABLES -------------
VPC_ID="vpc-xxxxxxxx"                     # 👈 VPC ID where SG will be created
GROUP_NAME="my-security-group"           # 👈 Name of the security group
DESCRIPTION="Custom security group"      # 👈 Description for your SG
REGION="us-east-1"                       # 👈 AWS region
TAGS="Key=Environment,Value=Dev"         # 👈 Tags (optional)

# Example ingress rule: [protocol port cidr]
INGRESS_RULES=(
  "tcp 22 0.0.0.0/0"        # SSH
  "tcp 80 0.0.0.0/0"        # HTTP
  "tcp 443 0.0.0.0/0"       # HTTPS
)

# Example egress rule (default allows all): [protocol port cidr]
EGRESS_RULES=(
  "tcp 443 0.0.0.0/0"
)

# -------------- CREATE SECURITY GROUP --------------
echo "Creating security group: $GROUP_NAME in VPC: $VPC_ID..."

SG_ID=$(aws ec2 create-security-group \
  --group-name "$GROUP_NAME" \
  --description "$DESCRIPTION" \
  --vpc-id "$VPC_ID" \
  --region "$REGION" \
  --tag-specifications "ResourceType=security-group,Tags=[$TAGS]" \
  --query 'GroupId' \
  --output text)

echo "✅ Created Security Group with ID: $SG_ID"

# -------------- AUTHORIZE INGRESS RULES --------------
echo "Adding ingress rules..."
for RULE in "${INGRESS_RULES[@]}"; do
  PROTOCOL=$(echo $RULE | awk '{print $1}')
  PORT=$(echo $RULE | awk '{print $2}')
  CIDR=$(echo $RULE | awk '{print $3}')
  echo "Allowing $PROTOCOL on port $PORT from $CIDR"
  aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol "$PROTOCOL" \
    --port "$PORT" \
    --cidr "$CIDR" \
    --region "$REGION"
done

# -------------- AUTHORIZE EGRESS RULES --------------
echo "Adding egress rules..."
for RULE in "${EGRESS_RULES[@]}"; do
  PROTOCOL=$(echo $RULE | awk '{print $1}')
  PORT=$(echo $RULE | awk '{print $2}')
  CIDR=$(echo $RULE | awk '{print $3}')
  echo "Allowing $PROTOCOL on port $PORT to $CIDR"
  aws ec2 authorize-security-group-egress \
    --group-id "$SG_ID" \
    --protocol "$PROTOCOL" \
    --port "$PORT" \
    --cidr "$CIDR" \
    --region "$REGION"
done

echo "✅ Security Group $GROUP_NAME ($SG_ID) configured successfully."
