FROM oven/bun:1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    jq \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install iii engine
RUN curl -fsSL https://install.iii.dev/iii/main/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Copy config
COPY config.yaml ./config.yaml

# Copy worker files
COPY workers/caller-worker/package.json workers/caller-worker/bun.lock ./
RUN bun install --frozen-lockfile

COPY workers/caller-worker/src ./src
COPY workers/caller-worker/tsconfig.json ./

ENV III_URL=ws://0.0.0.0:49134

CMD ["sh", "-c", "iii --config config.yaml & sleep 5"]