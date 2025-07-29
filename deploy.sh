#!/bin/bash
set -e

# Install awslocal if not present
command -v awslocal >/dev/null 2>&1 || pip install awscli-local --break-system-packages

# Create buckets
awslocal s3 mb s3://my-upload-bucket
awslocal s3 mb s3://my-resized-bucket

# Following is now installed and packaged through a docker container
# # Create zip for Lambda
# cd lambda
# pip install -r ../requirements.txt -t .
# zip -r ../lambda.zip .
# cd ..

# Create Lambda function
awslocal lambda create-function \
  --function-name imageResizer \
  --runtime python3.9 \
  --handler handler.lambda_handler \
  --zip-file fileb://lambda/lambda.zip \
  --role arn:aws:iam::000000000000:role/lambda-ex \
  --environment Variables="{AWS_ACCESS_KEY_ID=test,AWS_SECRET_ACCESS_KEY=test}" \
  --endpoint-url http://localhost:4566

# Add permission for S3 to invoke Lambda
# --statement-id: unique identifier for permission
# --principal: who can invoke
# --source-arn: which s3 bucket is allowed to trigger the func
awslocal lambda add-permission \
  --function-name imageResizer \
  --statement-id s3invoke \
  --action lambda:InvokeFunction \
  --principal s3.amazonaws.com \
  --source-arn arn:aws:s3:::my-upload-bucket \
  --source-account 000000000000

# Create S3 event trigger
# Uses s3:ObjectCreated:* to trigger on any upload
awslocal s3api put-bucket-notification-configuration \
  --bucket my-upload-bucket \
  --notification-configuration file://notification-config.json
