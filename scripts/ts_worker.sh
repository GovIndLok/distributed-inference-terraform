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

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

echo 'export BUN_INSTALL="$HOME/.bun"' >> "$HOME/.bashrc"
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> "$HOME/.bashrc"

# Installing iii engine

curl -fsSL https://install.iii.dev/iii/main/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
iii --version
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"

# Clone Repo

git clone https://github.com/GovIndLok/distributed-inference-terraform.git distributed-inference

# Entering quickstart

cd distributed-inference/quickstart

# Installing TS Dependencies
cd workers/caller-worker
bun install
cd ../..

# START III ENGINE

nohup iii --config config.yaml \
    >/var/log/iii-engine.log 2>&1 &

echo "Waiting for III engine startup..."

sleep 15

# Connect Caller Worker

export III_URL="ws://localhost:49134"
export III_SANDBOX=process

iii worker add ./workers/caller-worker
