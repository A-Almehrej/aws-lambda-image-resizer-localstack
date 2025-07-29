#!/bin/bash
set -e

# Variables
LAMBDA_DIR="./lambda"
OUTPUT_ZIP="lambda.zip"
PYTHON_VERSION="3.9"
REQUIREMENTS_FILE="requirements.txt"

echo "🔧 Building Lambda package using Docker..."

# Run Docker container to install deps and zip everything
docker run --rm \
  -v "$PWD/$LAMBDA_DIR":/app \
  -w /app \
  python:$PYTHON_VERSION \
  bash -c "
    apt-get update && \
    apt-get install -y zip && \
    pip install -r $REQUIREMENTS_FILE -t /app/build && \
    cp handler.py /app/build/ && \
    cd /app/build && \
    zip -r /app/$OUTPUT_ZIP ."

echo "✅ Lambda package created: $OUTPUT_ZIP"
