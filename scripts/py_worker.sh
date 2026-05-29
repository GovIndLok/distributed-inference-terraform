#!/bin/bash

set -euxo pipefail

exec >/var/log/py-worker-bootstrap.log 2>&1

echo "=-=-= PY worker Bootstrap =-=-="

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

# Installing iii engine

curl -fsSL https://install.iii.dev/iii/main/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
iii --version
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"

# Clone Repo

git clone https://github.com/GovIndLok/distributed-inference-terraform.git distributed-inference

# Entering quickstart

cd distributed-inference/quickstart

# Installing Python Dependencies (system-level — VM is dedicated to this worker)

cd workers/inference-worker

pip3 install --upgrade pip

pip3 install -r requirements.txt

# Connecting to remote iii engine

export III_URL="ws://${ts_private_ip}:49134"

# Connect Inference Worker (back at quickstart root)

cd ../..
export III_SANDBOX=process

iii worker add ./workers/inference-worker
