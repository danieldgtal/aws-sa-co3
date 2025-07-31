#!/bin/bash

# VPC Connectivity Troubleshooting Script
VPC_ID="vpc-02c946c5dba80afbb"
SUBNET_ID="subnet-0e3975d7ac071471c"
SG_ID="sg-031d4dae079ace442"

echo "🔍 VPC Connectivity Troubleshooting for VPC: $VPC_ID"
echo "=================================================="

# 1. Check Internet Gateway
echo "1️⃣ Checking Internet Gateway..."
IGW=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text 2>/dev/null)

if [[ "$IGW" == "None" || -z "$IGW" ]]; then
    echo "❌ No Internet Gateway attached to VPC $VPC_ID"
    echo "   Fix: Attach an Internet Gateway to your VPC"
else
    echo "✅ Internet Gateway found: $IGW"
fi

# 2. Check Route Table
echo ""
echo "2️⃣ Checking Route Table for subnet $SUBNET_ID..."
ROUTE_TABLE=$(aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=$SUBNET_ID" --query "RouteTables[0].RouteTableId" --output text 2>/dev/null)

if [[ "$ROUTE_TABLE" == "None" || -z "$ROUTE_TABLE" ]]; then
    echo "❌ No explicit route table association found"
    # Check main route table
    ROUTE_TABLE=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" "Name=association.main,Values=true" --query "RouteTables[0].RouteTableId" --output text)
    echo "   Using main route table: $ROUTE_TABLE"
fi

# Check for internet route (0.0.0.0/0)
INTERNET_ROUTE=$(aws ec2 describe-route-tables --route-table-ids "$ROUTE_TABLE" --query "RouteTables[0].Routes[?DestinationCidrBlock=='0.0.0.0/0'].GatewayId" --output text 2>/dev/null)

if [[ "$INTERNET_ROUTE" == "None" || -z "$INTERNET_ROUTE" ]]; then
    echo "❌ No internet route (0.0.0.0/0) found in route table $ROUTE_TABLE"
    echo "   Fix: Add route 0.0.0.0/0 pointing to Internet Gateway"
else
    echo "✅ Internet route found: $INTERNET_ROUTE"
fi

# 3. Check Subnet Public IP Assignment
echo ""
echo "3️⃣ Checking subnet public IP assignment..."
PUBLIC_IP_ON_LAUNCH=$(aws ec2 describe-subnets --subnet-ids "$SUBNET_ID" --query "Subnets[0].MapPublicIpOnLaunch" --output text)

if [[ "$PUBLIC_IP_ON_LAUNCH" == "false" ]]; then
    echo "⚠️ Subnet does not auto-assign public IPs"
    echo "   Note: Your script uses --associate-public-ip-address, so this should be OK"
else
    echo "✅ Subnet auto-assigns public IPs"
fi

# 4. Check Network ACL
echo ""
echo "4️⃣ Checking Network ACL..."
NACL_ID=$(aws ec2 describe-subnets --subnet-ids "$SUBNET_ID" --query "Subnets[0].NetworkAclId" --output text)
echo "   Network ACL ID: $NACL_ID"

# Check inbound rules for SSH (port 22)
SSH_INBOUND=$(aws ec2 describe-network-acls --network-acl-ids "$NACL_ID" --query "NetworkAcls[0].Entries[?RuleAction=='allow' && PortRange.From<=\`22\` && PortRange.To>=\`22\` && !Egress]" --output text)

if [[ -z "$SSH_INBOUND" ]]; then
    echo "❌ Network ACL may be blocking inbound SSH (port 22)"
else
    echo "✅ Network ACL allows inbound SSH"
fi

# Check outbound rules
SSH_OUTBOUND=$(aws ec2 describe-network-acls --network-acl-ids "$NACL_ID" --query "NetworkAcls[0].Entries[?RuleAction=='allow' && Egress]" --output text)

if [[ -z "$SSH_OUTBOUND" ]]; then
    echo "❌ Network ACL may be blocking outbound traffic"
else
    echo "✅ Network ACL allows outbound traffic"
fi

# 5. Check Security Group
echo ""
echo "5️⃣ Checking Security Group $SG_ID..."
SSH_SG_RULE=$(aws ec2 describe-security-groups --group-ids "$SG_ID" --query "SecurityGroups[0].IpPermissions[?FromPort==\`22\` && ToPort==\`22\`]" --output text)

if [[ -z "$SSH_SG_RULE" ]]; then
    echo "❌ Security Group does not allow SSH (port 22)"
    echo "   Fix: Add inbound rule for port 22"
else
    echo "✅ Security Group allows SSH"
fi

# 6. Check if this is a public or private subnet
echo ""
echo "6️⃣ Subnet Classification..."
if [[ "$IGW" != "None" && -n "$IGW" && "$INTERNET_ROUTE" != "None" && -n "$INTERNET_ROUTE" ]]; then
    echo "✅ This appears to be a PUBLIC subnet"
else
    echo "❌ This appears to be a PRIVATE subnet"
    echo "   Private subnets cannot receive direct internet traffic"
    echo "   You need either:"
    echo "   - Move to a public subnet, OR"
    echo "   - Use a NAT Gateway/Instance for outbound, and bastion host for SSH access"
fi

echo ""
echo "=================================================="
echo "🏁 Troubleshooting Summary Complete"

# Provide fix commands if issues found
echo ""
echo "🔧 Quick Fixes (if needed):"
echo ""

if [[ "$IGW" == "None" || -z "$IGW" ]]; then
    echo "# Create and attach Internet Gateway:"
    echo "IGW_ID=\$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)"
    echo "aws ec2 attach-internet-gateway --internet-gateway-id \$IGW_ID --vpc-id $VPC_ID"
    echo ""
fi

if [[ "$INTERNET_ROUTE" == "None" || -z "$INTERNET_ROUTE" ]]; then
    echo "# Add internet route to route table:"
    echo "aws ec2 create-route --route-table-id $ROUTE_TABLE --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW"
    echo ""
fi

if [[ -z "$SSH_SG_RULE" ]]; then
    echo "# Add SSH rule to security group:"
    echo "aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0"
    echo ""
fi