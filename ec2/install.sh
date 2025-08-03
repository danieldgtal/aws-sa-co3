#!/bin/bash
# Usage: ./deploy.sh <instance-ip>
## This scripts is used to deploy a script against an instance.

#########
# Part 1: Deploys the kind installation script to an EC2 instance
#########
if [ $# -eq 0 ]; then
    echo "Usage: $0 <instance-ip>"
    echo "Example: $0 54.123.45.67"
    exit 1
fi
## You have to pass the instance IP as an argument
# Example: ./deploy.sh 52.130.2.108
INSTANCE_IP=$1
echo "🚀 Deploying Kind installation to $INSTANCE_IP..."

scp -i ./nginx-ec2.pem install-kind-cluster.sh ubuntu@$INSTANCE_IP:/tmp/ && \
ssh -i ./nginx-ec2.pem ubuntu@$INSTANCE_IP "chmod +x /tmp/install-kind-cluster.sh && sudo /tmp/install-kind-cluster.sh"

echo "✅ Deployment complete!"