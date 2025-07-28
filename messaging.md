# 📬 AWS Messaging and Streaming Services

This README provides a concise but exam-relevant summary of AWS messaging and streaming services. It is tailored for AWS Solutions Architect Associate (SAA-C03) exam preparation and covers:

- SQS
- SNS
- EventBridge
- Kinesis (Data Streams & Firehose)
- Amazon MQ
- Key comparisons

---

## 📦 1. Amazon SQS (Simple Queue Service)

**Purpose:** Decouples microservices, distributed systems, and serverless apps.

### 🛠️ Features:
- Managed **message queuing service**
- Two types: **Standard (at-least-once)** and **FIFO (exactly-once, ordered)**
- **Message retention**: Up to 14 days
- Supports **dead-letter queues**
- **Pull-based** model (consumers poll the queue)

### 🔥 Use Cases:
- Job queueing
- Task offloading (e.g., to background workers)

---

## 📣 2. Amazon SNS (Simple Notification Service)

**Purpose:** Pub/Sub (fan-out) messaging to multiple subscribers.

### 🛠️ Features:
- Sends messages to:
  - SQS, Lambda, HTTP(S), SMS, Email
- Supports message filtering (by attributes)
- Push-based model
- **No message retention**

### 🔥 Use Cases:
- Application alerts
- Fan-out messages to multiple endpoints

---

## 🎯 3. Amazon EventBridge

**Purpose:** Event-driven architecture with intelligent routing.

### 🛠️ Features:
- Serverless **event bus**
- Accepts events from AWS services, SaaS apps, and custom apps
- Event filtering by **rules**
- Supports schema registry and transformation

### 🔥 Use Cases:
- Cross-account or cross-service event ingestion
- Audit trails
- SaaS integration (e.g., Zendesk, Datadog)

---

## 🔄 4. Amazon Kinesis

### 📊 4.1. Kinesis Data Streams

**Purpose:** Real-time stream ingestion and processing

#### 🛠️ Features:
- Shard-based throughput (scalable)
- Millisecond latency
- 1 MB or 1,000 records/sec per shard
- Retention: 24 hrs to 365 days

#### 🔥 Use Cases:
- Real-time analytics
- IoT telemetry ingestion

---

### 🚰 4.2. Kinesis Data Firehose

**Purpose:** Load streaming data into S3, Redshift, OpenSearch

#### 🛠️ Features:
- **Fully managed**, serverless
- Automatic scaling
- Near real-time delivery
- Can transform data with Lambda

#### 🔥 Use Cases:
- Ingest logs into S3
- Real-time dashboards
- Data lake ingestion

---

## 🔗 5. Amazon MQ

**Purpose:** Lift-and-shift for existing messaging systems (e.g., ActiveMQ, RabbitMQ)

### 🛠️ Features:
- Supports open protocols: AMQP, MQTT, JMS, STOMP
- Message durability
- Supports transactions, retries

### 🔥 Use Cases:
- Legacy apps using JMS or RabbitMQ
- Hybrid on-premises to cloud message broker

---

## 🔍 Feature Comparison Table

| Feature                | SQS        | SNS        | EventBridge | Kinesis Streams | Firehose     | Amazon MQ     |
|------------------------|------------|------------|-------------|------------------|--------------|----------------|
| Messaging Pattern      | Queue      | Pub/Sub    | Event Bus   | Stream           | Delivery     | Broker         |
| Retention              | 14 days    | None       | 24 hours    | Up to 365 days   | Minutes      | Configurable   |
| Ordering Support       | FIFO       | No         | No          | Yes (per shard)  | No           | Yes            |
| Push or Pull           | Pull       | Push       | Push        | Pull             | Push         | Push           |
| Serverless             | Yes        | Yes        | Yes         | Yes              | Yes          | No             |
| Throughput             | High       | High       | Moderate    | High             | High         | Moderate       |

---

## 🧠 Exam Tips

- **Use SQS for decoupling** components and queueing jobs.
- **Use SNS** to **fan out**
