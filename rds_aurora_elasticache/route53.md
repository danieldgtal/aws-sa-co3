# 📘 AWS Route 53 - Exam Study Guide

Amazon Route 53 is a **highly available and scalable Domain Name System (DNS) web service** designed to route users to applications based on multiple routing policies, health checks, and global infrastructure.

---

## 🚀 Key Concepts

| Concept | Description |
|--------|-------------|
| **DNS** | Translates domain names (like `example.com`) to IP addresses. |
| **Hosted Zone** | A container for records that define how to route traffic for a domain. |
| **Record Set** | Defines how you want to route traffic for a specific domain (A, AAAA, CNAME, etc). |
| **Health Checks** | Used to determine the health of endpoints (can trigger failovers). |

---

## 🌐 Record Types

| Record | Description |
|--------|-------------|
| **A** | Maps a domain to an IPv4 address. |
| **AAAA** | Maps a domain to an IPv6 address. |
| **CNAME** | Maps a domain to another domain name (alias). |
| **MX** | Defines mail servers for a domain. |
| **NS** | Delegates a subdomain to another name server. |
| **TXT** | Used for SPF, DKIM, domain verification. |
| **SRV** | Defines service-specific endpoints. |
| **Alias** | Route 53-specific type for AWS resources (ELB, CloudFront, etc). No cost for queries. |

---

## 🛰️ Routing Policies

| Policy | Description | Use Case |
|--------|-------------|----------|
| **Simple** | One record per name. No health check support. | Default routing for a single resource. |
| **Weighted** | Split traffic across multiple resources based on weight. | A/B testing, gradual deployments. |
| **Latency** | Routes to the region with the lowest latency. | Performance optimization. |
| **Failover** | Primary/secondary setup based on health checks. | High availability setups. |
| **Geolocation** | Routes traffic based on the user’s location. | Geo-targeted content. |
| **Geoproximity** (with traffic bias) | Routes based on geographic proximity and bias setting (requires Route 53 Traffic Flow). | Fine-grained location routing. |
| **Multivalue Answer** | Like simple, but returns multiple healthy values. | Lightweight alternative to ELB. |

---

## ✅ Health Checks

- Can monitor:
  - An endpoint (IP, domain, or specific path)
  - Other Route 53 health checks (calculated checks)
  - CloudWatch alarms
- Can be associated with failover and multivalue records.
- Supports automatic failover (Failover policy).

---

## 🛡️ Route 53 + AWS Services

| Service | Integration |
|--------|-------------|
| **ELB** | Use Alias record to route traffic to ELB (Apex/root domain supported). |
| **S3 Static Website** | Alias record for routing to the website endpoint. |
| **CloudFront** | Use Alias record for CDN endpoints. |
| **Global Accelerator** | Can be used with Route 53 as a global endpoint. |

---

## 💰 Pricing Model

- Charged per hosted zone (first 25 are cheap, then higher)
- DNS query volume-based pricing
- Health checks billed per check

---

## 🧠 Exam Tips (SAA-C03)

✅ **Alias vs CNAME**
- Alias: only within AWS; supports root domain; **no cost**
- CNAME: standard DNS; **can’t be used at root domain**

✅ **Failover routing requires health checks**

✅ **Multivalue routing** supports health checks — lightweight load balancing.

✅ Route 53 is a **globally resilient service** — regionless by design.

✅ You can use **Geolocation routing** for **compliance** or **user experience** localization.

✅ **Weighted routing** is ideal for **gradual rollouts** (e.g., send 10% to new version).

✅ You can route to:
- EC2 public IPs
- Load Balancers
- S3 Static websites
- CloudFront distributions
- Elastic Beanstalk environments

✅ **Split-horizon DNS** is not natively supported, but you can emulate it with **private hosted zones** for VPCs.

---

## 🧩 Common Use Case Scenarios

1. **A/B Testing**: Use Weighted Routing to shift small traffic to a new version.
2. **Global Application**: Use Latency or Geolocation routing to direct traffic to nearest region.
3. **Disaster Recovery**: Failover routing with primary and secondary endpoints.
4. **Hybrid Cloud**: Use Private Hosted Zone with VPC to resolve internal domain names.

---

## 📚 Additional Resources

- [Route 53 Official Docs](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [Route 53 Routing Policy Decision Tree](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html)

---

## 📎 Bonus: Alias Record Targets (Free DNS Lookups)

Alias records can point to:
- Elastic Load Balancers (Classic, ALB, NLB)
- CloudFront distributions
- S3 buckets configured as static websites
- API Gateway custom domains
- Global Accelerator
- VPC endpoint services

---

