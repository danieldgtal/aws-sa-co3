# 📘 AWS RDS, Aurora, and ElastiCache – Deep Exam Guide (SAA-C03)

This guide covers key concepts and decision points for Amazon RDS, Aurora, and ElastiCache, tailored specifically for the AWS Certified Solutions Architect – Associate (SAA-C03) exam.

---

## 📦 Amazon RDS (Relational Database Service)

Managed relational database service for:

- MySQL
- PostgreSQL
- MariaDB
- Oracle
- Microsoft SQL Server
- Amazon Aurora

### ✅ Key Features

| Feature | Description |
|--------|-------------|
| Automated Backups | Enabled by default (7–35 days retention). Stored in S3. |
| Manual Snapshots | Persist until deleted. Can be shared or copied. |
| Multi-AZ | Synchronous replication for high availability. |
| Read Replicas | Asynchronous replication for read scaling. Can promote. |
| Encryption | At rest (KMS) and in transit (SSL). Must be enabled at creation. |
| Storage Options | GP3, IO1 (Provisioned IOPS), Magnetic (legacy) |
| Monitoring | Performance Insights, Enhanced Monitoring, CloudWatch |
| VPC Support | RDS instances live inside a VPC, use security/subnet groups. |

### 🧠 Exam-Specific Insights

- **Multi-AZ = HA**, **Read Replicas = scalability**
- Read replicas can be **cross-region** for MySQL/PostgreSQL
- Backups are taken from standby in Multi-AZ setups
- You cannot convert single-AZ to multi-AZ without downtime
- Read replicas can be promoted, breaking replication
- RDS auto-patches **minor versions only**

---

## 🌟 Amazon Aurora

Cloud-native, MySQL and PostgreSQL compatible DB engine:

- 5x faster than MySQL
- 3x faster than PostgreSQL
- Shared storage architecture across 6 copies in 3 AZs

### ✅ Aurora Features

| Feature | Description |
|--------|-------------|
| Aurora Replicas | Up to 15 replicas with <10ms replication lag |
| Aurora Global DB | Cross-region read and DR; <1s replication lag |
| Aurora Serverless v2 | Auto-scales compute capacity; cost-effective |
| Backtrack | Rewind to previous time (MySQL only) |
| Parallel Query | Pushes query execution to storage layer |
| Auto Storage Scaling | Automatically grows up to 128 TiB |
| Integrated Monitoring | CloudWatch, Performance Insights |

### 🧠 Exam-Specific Insights

- Aurora uses **shared storage**: no data copy between replicas
- Aurora Replicas support **failover**
- Aurora Serverless is ideal for **variable workloads**
- Aurora automatically spreads 6 copies of data across 3 AZs
- Aurora Global DB is ideal for **low-latency global reads** or DR
- **Backtrack ≠ backup** — use for dev/test not disaster recovery

---

## 🚀 Amazon ElastiCache

Fully managed **in-memory** data store and cache.

### 🔧 Engines

- **Redis** (feature-rich)
- **Memcached** (simple key-value store)

### ✅ Redis vs Memcached

| Feature | Redis | Memcached |
|--------|-------|-----------|
| Data Types | Rich (lists, sets, hash, pub/sub) | Strings only |
| Persistence | Yes (RDB, AOF) | No |
| Replication | Yes (multi-AZ support) | No |
| Clustering | Yes | Yes |
| Encryption (TLS) | Yes | No |
| Backup & Restore | Yes | No |
| Pub/Sub | Yes | No |
| Multi-threaded | No | Yes |

### 🧠 Exam-Specific Insights

- Use **Redis** for:
  - Session stores, pub/sub, persistence, complex data types
- Use **Memcached** for:
  - Simple caching, multi-threaded workloads
- Redis supports **multi-AZ with failover**
- Redis supports **backups**, **restores**, and **TLS**
- ElastiCache must be deployed **within a VPC**
- Ideal to reduce pressure on **RDS** or **Aurora** (query caching)

---

## 🧠 Decision Matrix (Common on Exams)

| Scenario | Best Service | Why |
|----------|--------------|-----|
| Need managed SQL DB | RDS | Supports multiple engines |
| Auto-scaling relational DB | Aurora Serverless v2 | Pay-per-use |
| Fast MySQL alternative | Aurora MySQL | 5x performance |
| Global read performance | Aurora Global DB | Cross-region replication |
| Read-heavy workload | Aurora Replicas or RDS Read Replicas | Scalability |
| Session caching | ElastiCache Redis | In-memory, sub-ms latency |
| Pub/Sub + persistence | Redis | Complex workloads |
| Simple cache, no persistence | Memcached | Lightweight |

---

## 🧪 Sample Exam Questions

### Q1. You’re running an RDS PostgreSQL instance with heavy read traffic. You need to reduce load and improve performance. What’s the best solution?
- A. Enable Multi-AZ  
- B. Create Read Replicas  
- C. Enable Performance Insights  
- D. Increase instance size  
✅ **Answer: B**

---

### Q2. Your dev team needs a relational DB that auto-scales and incurs no cost when idle. What’s best?
- A. RDS MySQL  
- B. Aurora MySQL  
- C. Aurora Serverless v2  
- D. ElastiCache Redis  
✅ **Answer: C**

---

### Q3. You need to store session data in-memory with low latency and automatic failover. Which should you use?
- A. Memcached  
- B. DynamoDB  
- C. RDS Multi-AZ  
- D. ElastiCache Redis  
✅ **Answer: D**

---

## ✅ Final Checklist Before Exam

- [x] RDS: Multi-AZ = HA, Read Replica = Scalability
- [x] Aurora = AWS-native, faster, more scalable than RDS
- [x] Aurora Serverless = cost-efficient for sporadic use
- [x] ElastiCache = reduces DB load, supports session cache
- [x] Redis vs Memcached – know the differences
- [x] Backtrack vs Backup (Aurora)
- [x] Know storage scaling limits (Aurora: 128 TiB)
- [x] Encryption & VPC requirements

---

## 📚 Related Topics to Review

- Disaster Recovery (Aurora Global DB)
- Cross-region Read Replicas (MySQL/PostgreSQL)
- CloudWatch metrics: CPU, IOPS, FreeStorage
- IAM for RDS and ElastiCache
- Security groups for DB and cache access

---
