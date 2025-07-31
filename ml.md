# 📚 AWS Machine Learning Services – Cheat Sheet for AWS SAA-C03

This guide summarizes key AWS Machine Learning services you need to know for the **AWS Solutions Architect Associate (SAA-C03)** exam and real-world multi-cloud work.

---

## 🧠 Core AI/ML Services

### 1. **Amazon SageMaker**
- **Purpose:** End-to-end platform to build, train, and deploy machine learning models at scale.
- **Key Features:**
  - SageMaker Studio: IDE for ML
  - Built-in algorithms, Jupyter notebooks
  - Model training, tuning (Hyperparameter optimization), hosting (endpoints)
  - AutoML via SageMaker Autopilot
  - SageMaker Ground Truth for data labeling
- **Ideal For:** Data scientists, ML engineers, AI-based SaaS builders

---

## 🤖 AI Services (Pretrained, No ML Experience Needed)

### 2. **Amazon Rekognition**
- **Purpose:** Image and video analysis
- **Features:** Face detection, emotion detection, object & label recognition, text in image, unsafe content
- **Use Case:** ID verification, moderation, visual search

---

### 3. **Amazon Transcribe**
- **Purpose:** Speech-to-text (ASR – Automatic Speech Recognition)
- **Features:** Custom vocabularies, real-time transcription, speaker identification
- **Use Case:** Call center analysis, subtitles, voice search

---

### 4. **Amazon Polly**
- **Purpose:** Text-to-speech (TTS)
- **Features:** Realistic voice synthesis (neural TTS), multiple languages and accents
- **Use Case:** Audiobooks, accessibility tools, virtual assistants

---

### 5. **Amazon Translate**
- **Purpose:** Real-time and batch text translation
- **Features:** Neural machine translation, 75+ languages
- **Use Case:** Multilingual websites, apps, support automation

---

### 6. **Amazon Lex**
- **Purpose:** Build conversational chatbots with voice/text using the same tech as Alexa
- **Features:** NLP, intent recognition, multi-turn conversation flow, speech input/output
- **Use Case:** Customer service bots, appointment booking bots

---

### 7. **Amazon Comprehend**
- **Purpose:** Natural language processing (NLP)
- **Features:** Entity recognition, sentiment analysis, key phrases, syntax, language detection
- **Use Case:** Text analytics, review sentiment, legal/doc scanning

---

### 8. **Amazon Kendra**
- **Purpose:** Intelligent search powered by ML
- **Features:** Semantic search, relevance ranking, connectors for SharePoint, S3, databases
- **Use Case:** Enterprise knowledge base, document search

---

### 9. **Amazon Forecast**
- **Purpose:** Time-series forecasting
- **Features:** Predict future values like demand, inventory, metrics using historical data
- **Use Case:** Sales forecasting, resource planning, cost prediction

---

### 10. **Amazon Personalize**
- **Purpose:** Real-time recommendation engine
- **Features:** Similar to what powers Amazon.com, uses user/item interaction data
- **Use Case:** Product recommendations, content feeds, user personalization

---

### 11. **Amazon Connect**
- **Purpose:** Cloud-based contact center with AI-powered features
- **Features:** Integrates with Lex (chatbot), Transcribe (call analytics), and Contact Lens (comprehend+search)
- **Use Case:** Intelligent call routing, call analysis, chatbot support for contact centers

---

## 🧩 Additional Related ML Services

### 12. **AWS Textract**
- **Purpose:** Extract structured data from scanned documents
- **Features:** Reads tables, forms, handwriting
- **Use Case:** Invoice processing, OCR automation, form digitization

### 13. **AWS Inferentia**
- **Purpose:** High-performance inference chip for ML models
- **Use Case:** Lower-cost inference at scale (usually used in SageMaker deployment)

### 14. **AWS Deep Learning AMIs & Containers**
- **Purpose:** Preconfigured environments for ML/DL frameworks (TensorFlow, PyTorch, MXNet)
- **Use Case:** Custom ML workloads on EC2

---

## 🧠 AWS ML Exam Tips

- Know **SageMaker is for custom ML pipelines**, others are **pretrained AI services**.
- **Comprehend** → NLP / Sentiment
- **Kendra** → Intelligent Search
- **Lex** vs **Polly** → Lex is for conversation (NLP), Polly is for voice (TTS)
- **Rekognition** → Image & video
- **Textract** → OCR documents
- **Forecast** vs **Personalize**:
  - Forecast → Time-series data prediction
  - Personalize → Recommendation engines
- **Use case questions** are common (e.g., “Which service would you use to extract text from scanned PDFs?” → Textract)

---

## ✅ Summary

| Service         | Category            | Primary Use                                 |
|----------------|---------------------|----------------------------------------------|
| SageMaker       | ML platform         | Build/train/deploy ML models                |
| Rekognition     | AI vision           | Face, label, object detection in media      |
| Transcribe      | AI speech           | Convert speech to text                      |
| Polly           | AI speech           | Convert text to speech                      |
| Translate       | AI NLP              | Real-time translation                       |
| Lex             | AI NLP              | Build chatbots                              |
| Comprehend      | AI NLP              | Sentiment, entity analysis                  |
| Kendra          | AI Search           | Semantic search engine                      |
| Forecast        | ML forecasting      | Predict time-series data                    |
| Personalize     | ML personalization  | User recommendation engine                  |
| Connect         | Contact center AI   | Cloud call center w/ AI integration         |
| Textract        | AI vision           | Extract text/forms/tables from documents    |

---

