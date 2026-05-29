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

# Add Docker's official GPG key:
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Start Docker
sudo systemctl start docker

# Clone Repo

git clone https://github.com/GovIndLok/distributed-inference-terraform.git distributed-inference

# Entering quickstart

cd distributed-inference/quickstart

docker run -d --restart unless-stopped -p 3111:3111 -p 4132:4132 inference_worker:latest
