UBUNTU_AMI=$(aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*" \
           "Name=state,Values=available" \
  --query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' \
  --output text)

echo "Found Ubuntu 22.04 LTS AMI: $UBUNTU_AMI"

aws ec2 run-instances \
  --image-id $UBUNTU_AMI \
  --count 1 \
  --instance-type t3a.xlarge \
  --key-name nginx-ec2 \
  --subnet-id subnet-0e3975d7ac071471c \
  --user-data file://install-kind-cluster.sh \
  --security-group-ids sg-031d4dae079ace442 \
  --associate-public-ip-address

# For existing instance (replace with your instance tag/IP)
INSTANCE_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=your-instance-name" --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
scp -i ~/.ssh/nginx-ec2.pem install-kind.sh ubuntu@$INSTANCE_IP:/tmp/ && ssh -i ~/.ssh/your-key.pem ubuntu@$INSTANCE_IP "chmod +x /tmp/install-kind.sh && sudo /tmp/install-kind.sh"  