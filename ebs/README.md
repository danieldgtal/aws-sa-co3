# 📦 Amazon EBS (Elastic Block Store) - SAA-C03 Quick Guide

Amazon Elastic Block Store (EBS) provides persistent block-level storage volumes for EC2 instances. EBS volumes behave like raw, unformatted block devices and can be attached to instances for file systems, databases, and applications.

---

## 🔹 Key Characteristics

- Persistent storage (survives instance stop/start).
- Automatically replicated within the same Availability Zone.
- Can be attached to a single EC2 instance at a time (except for **multi-attach** with io1/io2).
- Snapshots can be taken and stored in S3 (for backup or cross-AZ/region copy).
- Volumes can be encrypted using AWS KMS.

---

## 🔸 Volume Types Overview

| Volume Type | Category | Description | Use Cases | Max IOPS / Throughput |
|-------------|----------|-------------|-----------|------------------------|
| `gp3`       | SSD      | General Purpose SSD (latest) | Boot volumes, general workloads | 16,000 IOPS / 1,000 MBps |
| `gp2`       | SSD      | General Purpose SSD (older)  | Balanced workloads     | 3 IOPS/GB, up to 3,000 IOPS |
| `io2` / `io1` | SSD    | Provisioned IOPS SSD          | Databases, SAP, critical apps | 256,000 IOPS (io2 Block Express) |
| `st1`       | HDD      | Throughput-Optimized HDD      | Big data, streaming     | 500 MBps (burst) |
| `sc1`       | HDD      | Cold HDD, lowest cost         | Archival, infrequent access | 250 MBps (burst) |

---

## ⚙️ SSD vs HDD Breakdown

- **SSD-based (gp3, gp2, io1, io2)**:
  - Random I/O
  - Low latency
  - High IOPS

- **HDD-based (st1, sc1)**:
  - Sequential I/O
  - High throughput
  - Cost-effective for bulk data

---

## 📌 Key Features

- **Encryption**: In-transit and at-rest, integrated with AWS KMS.
- **Snapshots**: Point-in-time backup stored in S3.
- **Multi-Attach**: Only for `io1` / `io2`, allows attaching to multiple EC2 instances in the same AZ.
- **Resize**: Volumes can be resized without downtime.
- **Performance**: `gp3` allows you to provision IOPS and throughput independently of size.

---

## 🧠 Exam Tips (SAA-C03)

✅ **gp3 vs gp2**  
- gp3 is the newer default, supports separate tuning of IOPS and throughput.  
- gp2 performance is tied to volume size (3 IOPS/GB).

✅ **io2/io1**  
- Use for **critical databases** requiring high IOPS and durability (e.g., Oracle, SAP).
- Only io1/io2 support **Multi-Attach**.

✅ **st1 vs sc1**  
- `st1` is for **frequently accessed, large, sequential files**.  
- `sc1` is for **infrequent access** where cost is the priority.

✅ **Snapshots**  
- Stored in S3 automatically.
- Can be used to create a new volume in a **different AZ or region**.

✅ **AZ Limitation**  
- Volumes are **tied to an AZ**, must be in the same AZ as the EC2 instance.

✅ **Monitoring**  
- Use **CloudWatch metrics** like VolumeReadOps, VolumeWriteOps, VolumeQueueLength.

---

## 🔍 Sample Scenario

> You are running a MySQL database that requires 10,000 IOPS and high durability. Which EBS volume type should you choose?

✅ **Answer**: `io2`

> You have a log processing pipeline reading large sequential files. Which volume type should you choose?

✅ **Answer**: `st1`

---

## 📘 AWS Docs

- [Amazon EBS Volume Types](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-volume-types.html)
- [EBS Pricing](https://aws.amazon.com/ebs/pricing/)
- [EBS and EC2 Integration](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AmazonEBS.html)

---

