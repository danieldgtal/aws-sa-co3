#!/bin/bash
set -e

echo "🔧 Updating package index..."
sudo apt-get update -y

echo "🐳 Installing Docker..."
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

echo "👤 Adding user to docker group..."
sudo usermod -aG docker $USER

echo "🔧 Applying Docker permissions (temporary fix)..."
sudo chmod 666 /var/run/docker.sock

echo "📦 Installing prerequisites for kubectl..."
sudo apt-get install -y apt-transport-https ca-certificates curl

echo "🔍 Detecting system architecture..."
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    arm64)
        ARCH="arm64"
        ;;
    *)
        echo "❌ Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
echo "📋 Detected architecture: $ARCH"

echo "📥 Downloading kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "✅ kubectl version:"
kubectl version --client

echo "🧠 Enabling kubectl autocompletion..."
sudo apt-get install -y bash-completion
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc

echo "📥 Downloading kind (latest version)..."
KIND_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kind/releases/latest | grep -Po '"tag_name": "\K[^"]*')
curl -Lo ./kind "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-${ARCH}"
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

echo "✅ kind version:"
kind version

echo ""
echo "🎉 Kind installation completed successfully!"
echo ""
echo "🔍 Testing Docker access..."
if docker ps > /dev/null 2>&1; then
    echo "✅ Docker is accessible - ready to create clusters!"
else
    echo "⚠️  Docker permissions issue detected. For permanent fix, log out and back in."
fi
echo ""
echo "📋 To create a cluster, run:"
echo "   kind create cluster --name my-cluster"
echo ""
echo "🔍 Other useful commands:"
echo "   kind get clusters              # List clusters"
echo "   kind delete cluster --name <name>  # Delete cluster"
echo "   kubectl cluster-info           # Check cluster info"