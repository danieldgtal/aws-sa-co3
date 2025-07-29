# AWS Container Services: ECS, ECR, EKS, App Runner, and App2Container

This document summarizes key concepts, architectural components, and exam-relevant facts about container services in AWS.

---

## 🚢 Amazon ECS (Elastic Container Service)

### ✅ Overview
Amazon ECS is a fully managed container orchestration service. It supports running Docker containers on a managed cluster of EC2 or Fargate.

### 🔧 Launch Types
- **EC2 Launch Type**: Manages your own EC2 instances as cluster nodes.
- **Fargate Launch Type**: Serverless, no need to manage EC2. Pay per pod.

### 📌 Key Concepts
- **Cluster**: Logical grouping of resources to run tasks.
- **Task Definition**: Blueprint for running containers (CPU, memory, port mappings, etc.)
- **Service**: Ensures the desired number of task instances are running.
- **Task**: An instantiation of a Task Definition.

### 🔐 Integration
- IAM roles per task (`taskRoleArn`)
- Secrets via SSM or Secrets Manager
- Logging via CloudWatch

---

## 📦 Amazon ECR (Elastic Container Registry)

### ✅ Overview
A fully managed Docker container registry that integrates with ECS, EKS, Lambda, and App Runner.

### 📌 Key Concepts
- **Private Repositories**: Default, can control access via IAM policies.
- **Public Repositories**: Optional, for open access.
- **Image Scanning**: Vulnerability scanning (Basic or Enhanced).

### 🔐 Security
- Integrated with IAM
- Supports encryption at rest using KMS

---

## ☸️ Amazon EKS (Elastic Kubernetes Service)

### ✅ Overview
EKS is AWS’s managed Kubernetes offering. It lets you run Kubernetes clusters without managing the control plane.

### 📌 Core Concepts
- **Control Plane**: Fully managed by AWS.
- **Worker Nodes**: EC2 or Fargate-based.
- **Node Groups**: Logical grouping of worker nodes.
- **Networking**: Uses VPC CNI plugin.

### 🔐 Security & IAM
- IAM roles for service accounts (IRSA)
- OIDC identity provider integration
- Secrets and ConfigMaps support

### 🧠 Exam Tips
- Know how to integrate EKS with **Fargate**, **IAM**, and **CloudWatch**.
- Know difference from ECS: EKS = Kubernetes; ECS = AWS-native.

---

## ⚡ AWS App Runner

### ✅ Overview
AWS App Runner is a fully managed service for deploying containerized web apps and APIs without managing infrastructure.

### 📌 Key Features
- Accepts source from ECR or GitHub
- Automatically builds and deploys apps
- Includes HTTPS, autoscaling, and health checks out-of-the-box

### 🧠 Exam Tips
- Best for developers with no infrastructure knowledge.
- Zero-config deployment (great for PaaS-like scenarios).
- Used for **web applications and APIs** only.

---

## 🛠️ AWS App2Container

### ✅ Overview
A command-line tool to modernize legacy applications into containers.

### 📌 Key Features
- Scans existing .NET or Java apps on VMs
- Generates Dockerfiles and ECS/EKS deployment artifacts
- Compatible with CI/CD workflows

### 🧠 Use Cases
- Lift-and-shift applications to ECS or EKS
- Ideal for monolith-to-container transformation

---

## 🧠 Quick Comparison

| Feature        | ECS                  | EKS                   | App Runner           | App2Container        |
|----------------|----------------------|------------------------|-----------------------|-----------------------|
| **Orchestrator** | ECS (native)         | Kubernetes             | Abstracted            | N/A (CLI tool)        |
| **Control Plane** | Managed or Self-managed | Fully Managed          | Fully Managed         | Local Tool            |
| **Deployment** | Task Def + Service   | K8s YAML / Helm        | GitHub / ECR          | Containerizes Legacy  |
| **Use Case**   | AWS-native workloads | Portable K8s workloads | Simplified Web Deploy | Containerizing legacy |
| **Serverless** | Yes (Fargate)        | Yes (Fargate)          | Yes                   | N/A                   |

---

## 📚 References
- [ECS Docs](https://docs.aws.amazon.com/ecs/)
- [EKS Docs](https://docs.aws.amazon.com/eks/)
- [ECR Docs](https://docs.aws.amazon.com/AmazonECR/latest/)
- [App Runner Docs](https://docs.aws.amazon.com/apprunner/)
- [App2Container Docs](https://docs.aws.amazon.com/app2container/)

---

## ✅ Summary for SAA-C03

- Know when to use **Fargate** vs **EC2** for ECS/EKS.
- ECR is the default AWS container registry and integrates well with all services.
- EKS = Kubernetes → requires understanding of K8s basics.
- App Runner = Simple containerized app deployment (PaaS style).
- App2Container is useful for modernizing legacy workloads.

