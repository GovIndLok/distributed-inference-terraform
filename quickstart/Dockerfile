FROM oven/bun:1

WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY workers/caller-worker .

RUN bun install --frozen-lockfile

ENV III_URL=ws://0.0.0.0:49134

CMD ["bun", "run", "src/worker.ts"]