# 🌐 AWS Load Balancers – SAA-C03 Exam Essentials

Amazon Elastic Load Balancing (ELB) automatically distributes incoming application traffic across multiple targets, such as EC2 instances, containers, IP addresses, or Lambda functions.

---

## 🔺 Types of Load Balancers

| Load Balancer       | OSI Layer | Use Case | Protocols | Key Features |
|---------------------|-----------|----------|-----------|--------------|
| **ALB** (Application) | Layer 7   | HTTP/HTTPS apps | HTTP, HTTPS | Host/path-based routing, WAF, target groups |
| **NLB** (Network)     | Layer 4   | Extreme performance / low latency | TCP, TLS, UDP | Millions of reqs/sec, static IP, preserve client IP |
| **CLB** (Classic)     | Layer 4 & 7 | Legacy workloads | HTTP, HTTPS, TCP | No longer recommended for new apps |
| **GWLB** (Gateway)    | Layer 3   | Third-party appliances | IP | Deploy firewall, IDS/IPS, packet inspection |

---

## 🎯 ALB – Application Load Balancer

- Layer 7: Intelligent routing (based on **path**, **host**, **query**, **headers**, etc.)
- Supports **WebSocket**, **gRPC**, and **Lambda** targets
- Target groups: EC2, ECS, Lambda, IP addresses
- Integrates with:
  - AWS WAF
  - AWS Cognito (OIDC auth)
  - HTTPS with ACM

📌 **Best for**: Microservices, container-based apps (ECS/EKS), web apps needing URL routing

---

## ⚡ NLB – Network Load Balancer

- Layer 4: Extremely **low latency**, **high performance**
- Supports static IP or **Elastic IP** per AZ
- Preserves source IP
- Works with **TLS**, **TCP**, **UDP**
- Integrates with **PrivateLink**

📌 **Best for**: High-performance apps, gaming, IoT, real-time systems

---

## ⚙️ CLB – Classic Load Balancer (LEGACY)

- Supports Layer 4 (TCP) and Layer 7 (HTTP/S)
- Deprecated for new designs
- No support for host/path-based routing

📌 **Use only** for legacy workloads

---

## 🧱 GWLB – Gateway Load Balancer

- Layer 3: Works at IP level
- Allows third-party virtual appliances (firewalls, deep packet inspection)
- Uses **Geneve protocol**

📌 **Best for**: Inserting **security appliances** into traffic flow

---

## 🛠️ Key Features (All ELBs)

- **Health Checks**: Ensure traffic is sent only to healthy targets.
- **Cross-Zone Load Balancing**:
  - **ALB & CLB**: Always on, no cost.
  - **NLB**: Optional, may incur extra data transfer charges.
- **Sticky Sessions**:
  - ALB: via app cookie or duration-based cookie
  - CLB: via duration-based cookie
- **SSL Termination**: ELBs can offload SSL cert handling
- **Access Logs**: Stored in S3 (enable for troubleshooting)

---

## 🧠 Exam Tips

✅ **ALB** = Use when:
- You need **path or host-based routing**.
- You’re serving **multiple microservices**.
- You want to serve **Lambda** via HTTP(S).
- You need **WebSocket** support.

✅ **NLB** = Use when:
- You need **extreme performance** or **TLS pass-through**.
- You want to **preserve client IP**.
- You're working with **TCP/UDP** (e.g., gRPC, gaming).

✅ **GWLB** = Use when:
- You're deploying **firewalls, IDS/IPS, or third-party appliances**.

✅ **Target Groups**:
- Reusable components to register targets
- One load balancer can route to **multiple target groups**

✅ **Health Checks**:
- Specific to target group
- Can be customized (protocol, path, port)

✅ **Elastic Load Balancer DNS names**:
- Do not use IP addresses directly (ELBs don’t have static IPs unless NLB with EIP)

---

## 🔍 Sample Scenario Questions

> You need to load balance a REST API with path-based routing and WebSocket support. Which ELB should you use?

✅ **Answer**: Application Load Balancer (ALB)

> You need to load balance TCP traffic with the lowest latency and support millions of requests per second.

✅ **Answer**: Network Load Balancer (NLB)

> You want to insert a third-party firewall appliance transparently in your VPC. Which ELB is appropriate?

✅ **Answer**: Gateway Load Balancer (GWLB)

---

## 📘 Helpful Links

- [Elastic Load Balancing Overview](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/what-is-load-balancing.html)
- [Choosing a Load Balancer Type](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/load-balancer-types.html)
- [Target Groups](https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/load-balancer-target-groups.html)

---
