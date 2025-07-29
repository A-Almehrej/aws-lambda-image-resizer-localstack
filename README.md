# 🖼️ Serverless Image Resizer (AWS Lambda + LocalStack)

A local-first, serverless image processing pipeline built with AWS Lambda, S3, and LocalStack — fully containerized with Docker. Upload an image, and the Lambda function automatically resizes and stores it.

---

## 🚀 Features

- Resize images on upload (128x128 thumbnail)
- Trigger AWS Lambda via S3 event
- Fully local: no AWS account needed
- Uses Docker + LocalStack to simulate:
  - Lambda
  - S3
  - IAM
  - CloudWatch

---

## 🧱 Architecture

[Upload Image to S3]

↓

[S3 Bucket: my-upload-bucket]

↓ triggers

[AWS Lambda: imageResizer]

↓

[Resized Image Saved to my-resized-bucket]

---

## 📦 Tech Stack

| Layer        | Tool              |
|--------------|-------------------|
| Compute      | AWS Lambda (Python) |
| Storage      | AWS S3             |
| Runtime Env  | Docker             |
| Local AWS    | LocalStack         |
| SDK          | boto3 + Pillow     |

---

## 🧰 Setup Instructions

### 1. Clone & Build Lambda Package
```bash
git clone https://github.com/yourname/aws-lambda-image-resizer-localstack.git
cd aws-lambda-image-resizer-localstack
./build-lambda.sh
```
### 2. Start LocalStack
```bash
docker-compose up -d
```
### 3. Deploy Resources
```bash
./deploy.sh
```
### 4. Upload an Image
```bash
awslocal s3 cp sq.png s3://my-upload-bucket/
```
### 5. Get Resized Output
```bash
awslocal s3 cp s3://my-resized-bucket/resized-test.jpg .
```