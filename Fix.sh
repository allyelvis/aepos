#!/bin/bash

# Define the paths
DOCKERFILE_PATH="./Dockerfile"
GITHUB_WORKFLOW_PATH=".github/workflows/docker-build.yml"

# Step 1: Check if Dockerfile exists, create one if missing
if [ ! -f "$DOCKERFILE_PATH" ]; then
  echo "Dockerfile missing. Creating Dockerfile..."
  cat <<EOF > "$DOCKERFILE_PATH"
# Base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy project files
COPY . .

# Command to run the application
CMD ["python", "main.py"]
EOF
  echo "Dockerfile created at $DOCKERFILE_PATH"
else
  echo "Dockerfile already exists."
fi

# Step 2: Check GitHub Actions workflow file and set Dockerfile path
if [ -f "$GITHUB_WORKFLOW_PATH" ]; then
  echo "Updating Dockerfile path in GitHub Actions workflow..."
  sed -i 's|docker build .|docker build -f ./Dockerfile .|' "$GITHUB_WORKFLOW_PATH"
else
  echo "GitHub Actions workflow file not found. Creating one..."
  mkdir -p "$(dirname "$GITHUB_WORKFLOW_PATH")"
  cat <<EOF > "$GITHUB_WORKFLOW_PATH"
name: Docker Build

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Build Docker Image
      run: docker build -f ./Dockerfile .
EOF
  echo "GitHub Actions workflow created at $GITHUB_WORKFLOW_PATH"
fi

# Step 3: Install an AI tool (e.g., Scikit-learn for Python)
if command -v pip &> /dev/null; then
  echo "Installing AI tool (Scikit-learn)..."
  pip install scikit-learn
  echo "Scikit-learn installed."
else
  echo "pip not found. Please install Python and pip first."
fi

echo "Setup complete."
