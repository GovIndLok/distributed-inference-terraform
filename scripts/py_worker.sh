#!/bin/bash

set -euxo pipefail

exec >/var/log/ts-worker-bootstrap.log 2>&1

echo "=-=-= PY worker Bootstrap =-=-="

# System update

apt-get update -y
apt-get upgrade -y

# Install Core Dependencies

apt-get Install -y \
    curl \
    git \
    unzip \
    build-essential \
    python3 \
    python3-pip \
    python3-venv

# Installing iii engine

curl -fsSL https://install.iii.dev/iii/main/install.sh | sh
iii -version

# Clone Repo

cd /opt

git clone https://github.com/GovIndLok/distributed-inference-terraform.git distributed-inference

# Entering quickstart

cd /opt/distributed-inference/quickstart

# Creating Python VENV

cd workers/inference-worker

python3 -m venv venv

source venv/bin/activate

# Installing Dependencies
pip install --upgrade pip

pip install -r requirements.txt

# Connecting to remote iii engine

export III_URL="ws://${ts_private_ip}:49134"

# Connect Inference Worker

cd /opt/distributed-inference/quickstart

iii worker add ./workers/inference-worker
