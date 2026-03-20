# ── Stage 1: Build xray-core from source ────────────────────────────────────
FROM golang:1.23-bookworm AS builder

ARG XRAY_VERSION=v25.12.30

# Install git for cloning
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Clone and build xray-core
WORKDIR /build
RUN git clone --depth 1 --branch ${XRAY_VERSION} https://github.com/XTLS/Xray-core.git . \
    && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
       go build -trimpath -ldflags "-s -w" \
       -o /usr/local/bin/xray ./main

# ── Stage 2: Minimal runtime ───────────────────────────────────────────────
FROM debian:bookworm-slim

# Install ca-certificates for TLS and jq for config templating
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates jq curl \
    && rm -rf /var/lib/apt/lists/*

# Copy xray binary
COPY --from=builder /usr/local/bin/xray /usr/local/bin/xray
RUN chmod +x /usr/local/bin/xray

# Copy config template and entrypoint
COPY xray-server-config.json /etc/xray/config.template.json
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Xray listens on port 8080 (XHTTP)
EXPOSE 8080

# Health check — xray responds to XHTTP GET on the configured path
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -sf http://localhost:8080/ || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
