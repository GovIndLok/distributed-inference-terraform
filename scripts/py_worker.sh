#!/bin/bash

set -euxo pipefail

exec >/var/log/py-worker-bootstrap.log 2>&1

echo "=-=-= PY worker Bootstrap =-=-="

# Navigate to home directory and create an app directory for the worker
cd ~/

# System update

apt-get update -y
apt-get upgrade -y

# Install Core Dependencies

apt-get install -y \
    curl \
    git \
    unzip \
    build-essential \
    python3 \
    python3-pip \
    python3-venv

# Fetch HF_TOKEN from SSM Parameter Store
export HF_TOKEN=$(aws ssm get-parameter \
    --name "/di/hf_token" \
    --with-decryption \
    --query "Parameter.Value" \
    --output text)

echo "HF_TOKEN fetched successfully"

# Clone Repo

git clone https://github.com/GovIndLok/distributed-inference-terraform.git distributed-inference

# Entering quickstart

cd distributed-inference/quickstart

# Installing Python Dependencies (system-level — VM is dedicated to this worker)

cd workers/inference-worker

python3 -m venv .venv
source .venv/bin/activate
pip3 install --upgrade pip
pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cpu # CPU-only PyTorch, remove this line if you want GPU support
pip3 install -r requirements.txt

# Connecting to remote iii engine

export III_URL="ws://${ts_private_ip}:49134"

# Connect Inference Worker (back at quickstart root)

cd ../..
python3 inference_worker.py