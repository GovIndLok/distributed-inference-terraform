#!/bin/bash

set -euxo pipefail

exec >/var/log/ts-worker-bootstrap.log 2>&1

echo "=-=-= TS worker Bootstrap =-=-="

cd ~/
# System update

apt-get update -y
apt-get upgrade -y

# Install Core Dependencies

apt-get install -y \
    curl \
    git \
    unzip \
    build-essential

# Add Docker's official GPG key:
apt install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

# Install Docker Engine
apt update -y
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Installing III engine
curl -fsSL https://install.iii.dev/iii/main/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
iii --version
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"

# Start Docker
systemctl start docker

# Clone Repo

git clone https://github.com/GovIndLok/distributed-inference-terraform.git distributed-inference

# Entering quickstart

cd distributed-inference/quickstart

# Build image from Dockerfile
docker build -t caller_worker:latest .

# Start the  III engine
nohup iii --config config.yaml &

iii worker add caller_worker:latest