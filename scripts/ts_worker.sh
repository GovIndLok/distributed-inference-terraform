#!/bin/bash

set -euxo pipefail

exec >/var/log/ts-worker-bootstrap.log 2>&1

echo "=-=-= TS worker Bootstrap =-=-="

# System update

apt-get update -y
apt-get upgrade -y

# Install Core Dependencies

apt-get install -y \
    curl \
    git \
    unzip \
    build-essential

# Install bun

curl -fsSL https://bun.sh/install | bash

export BUN_INSTALL="/root/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

echo 'export BUN_INSTALL="/root/.bun"' >>/root/.bashrc
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >>/root/.bashrc

# Installing iii engine

curl -fsSL https://install.iii.dev/iii/main/install.sh | sh
iii -version
echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.bashrc

# Clone Repo

cd /opt

git clone https://github.com/GovIndLok/distributed-inference-terraform.git distributed-inference

# Entering quickstart

cd /opt/distributed-inference/quickstart

# Installing TS Dependencies
bun install

# START III ENGINE

nohup iii --config config.yaml \
    >/var/log/iii-engine.log 2>&1 &

echo "Waiting for III engine startup..."

sleep 15

# Connect Caller Worker

export III_URL="ws://localhost:49134"
export III_SANDBOX=process

iii worker add ./workers/caller-worker
