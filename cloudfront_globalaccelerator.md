# 🌍 CloudFront & Global Accelerator – AWS SAA-C03 Exam Prep

This guide summarizes critical concepts, behaviors, and features of **Amazon CloudFront** and **AWS Global Accelerator**, tailored to what you may encounter on the AWS SAA-C03 exam.

---

## 🧊 Amazon CloudFront (CDN)

### ✅ What It Is
Amazon **CloudFront** is a **Content Delivery Network (CDN)** that **distributes content globally** via a network of **edge locations**, reducing latency and improving performance for users worldwide.

---

### ⚙️ Key Features

| Feature | Description |
|--------|-------------|
| **Edge Locations** | Physical data centers to cache content closer to users |
| **Origin** | The source of the content (S3, ALB, EC2, or external) |
| **Cache Behavior** | Controls how requests are handled and what is cached |
| **TTL (Time To Live)** | Determines how long content is cached at edge locations |
| **Signed URLs/Cookies** | Restrict access to specific users or sessions |
| **Origin Access Control (OAC)** | Secure access to S3 origins (replacing Origin Access Identity) |
| **HTTPS Support** | SSL/TLS encryption and ACM custom certificates |
| **Lambda@Edge** | Run Lambda functions at edge locations to modify requests/responses |

---

### 📦 Common Use Cases

- Distribute **static assets** (JS, CSS, images, videos)
- Serve **dynamic content** from EC2 or ALB
- Secure access to **S3 buckets** using **OAC**
- Reduce latency and offload traffic from origin servers
- Improve content delivery performance globally

---

### 🔐 Security Features

- **AWS Shield Standard**: DDoS protection included
- **WAF Integration**: Protect against malicious traffic
- **HTTPS-only enforcement**
- **Signed URLs/Cookies** for private content
- **Geo-restriction** to block countries/regions

---

### 📌 Exam Tips

- CloudFront is **not regional**; it uses **global edge locations**
- Use **OAC** (or legacy OAI) to restrict public access to S3 origins
- Supports **HTTP/2** and **TLS**
- Can cache both **static** and **dynamic** content
- Caching policy can be controlled via **TTL settings**
- Origin can be an **S3 bucket**, **ALB**, **EC2**, or **external URL**

---

## 🚀 AWS Global Accelerator

### ✅ What It Is
AWS **Global Accelerator** is a **network-level** service that **optimizes TCP and UDP traffic performance** by routing user traffic through the **AWS Global Network** instead of the public internet.

---

### ⚙️ Key Features

| Feature | Description |
|--------|-------------|
| **Static IPs** | Provides 2 static anycast IPs for global entry |
| **Accelerated Performance** | Traffic enters the closest AWS edge location and rides the optimized AWS backbone |
| **Health Checks** | Routes traffic only to healthy endpoints |
| **Regional Failover** | If one region fails, traffic automatically reroutes to the next closest healthy region |
| **Cross-Region Load Balancing** | Distributes traffic across regions based on latency or geolocation |
| **Traffic Dials** | Control percentage of traffic routed to each endpoint group |

---

### 📦 Use Cases

- **Global applications** needing fast, reliable performance
- **Multi-region failover and disaster recovery**
- Applications requiring **static IP addresses**
- Non-HTTP(S) protocols like **gaming**, **VoIP**, **IoT**

---

### 🆚 CloudFront vs Global Accelerator

| Feature                | CloudFront                         | Global Accelerator                     |
|------------------------|------------------------------------|----------------------------------------|
| **Use Case**           | Web content (HTTP/HTTPS)           | TCP/UDP apps across multiple regions   |
| **Caching**            | ✅ Yes                             | ❌ No                                  |
| **Performance**        | CDN optimized                      | Network routing optimized              |
| **Protocol**           | HTTP/S only                        | TCP/UDP                                |
| **Static IPs**         | ❌ No                              | ✅ Yes (anycast)                        |
| **Custom Origins**     | S3, EC2, ALB, etc.                 | ALB, NLB, EC2 IPs                      |
| **Global Failover**    | ❌ No (unless manual setup)        | ✅ Yes                                 |

---

### 📌 Exam Tips

- **CloudFront** is ideal for **web assets** and **caching**
- **Global Accelerator** is ideal for **real-time TCP/UDP apps** or if you need **static IPs**
- GA supports **cross-region failover**, **static anycast IPs**, and **accelerated performance**
- GA supports **ALBs, NLBs, EC2**, and **Elastic IPs** as **endpoints**

---

## 🧠 Final Notes

- Both services improve **latency**, but in **different layers**:
  - CloudFront → **Application-level (Layer 7)**
  - Global Accelerator → **Network-level (Layer 4)**
- You can use **CloudFront + Global Accelerator** together for:
  - Static & dynamic content caching (CF)
  - Static IPs and fast failover routing (GA)

---

## 📘 Resources

- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/index.html)
- [Global Accelerator Docs](https://docs.aws.amazon.com/global-accelerator/index.html)
- [Compare GA vs CloudFront](https://aws.amazon.com/global-accelerator/faqs/)

---
