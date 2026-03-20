#!/bin/sh
set -e

# ── Xray Container Entrypoint ──────────────────────────────────────────────
# Injects environment variables into the Xray config template and starts xray.
#
# Environment variables (set by Worker → Container envVars):
#   XRAY_UUID       — VLESS user UUID (required)
#   XRAY_PATH       — XHTTP request path (default: /xhttp)
#   XRAY_LOG_LEVEL  — Log level: debug, info, warning, error, none (default: warning)

XRAY_UUID="${XRAY_UUID:-00000000-0000-0000-0000-000000000000}"
XRAY_PATH="${XRAY_PATH:-/xhttp}"
XRAY_LOG_LEVEL="${XRAY_LOG_LEVEL:-warning}"

CONFIG_TEMPLATE="/etc/xray/config.template.json"
CONFIG_FILE="/etc/xray/config.json"

echo "╔══════════════════════════════════════════════════╗"
echo "║  Xray XHTTP Server — Cloudflare Container       ║"
echo "╠══════════════════════════════════════════════════╣"
echo "║  Transport: XHTTP                               ║"
echo "║  Port:      8080                                ║"
echo "║  Path:      ${XRAY_PATH}"
echo "║  Log Level: ${XRAY_LOG_LEVEL}"
echo "║  UUID:      ${XRAY_UUID:0:8}...                 ║"
echo "╚══════════════════════════════════════════════════╝"

# Render config from template using jq
jq \
  --arg uuid "$XRAY_UUID" \
  --arg path "$XRAY_PATH" \
  --arg loglevel "$XRAY_LOG_LEVEL" \
  '
    .log.loglevel = $loglevel |
    .inbounds[0].settings.clients[0].id = $uuid |
    .inbounds[0].streamSettings.xhttpSettings.path = $path
  ' \
  "$CONFIG_TEMPLATE" > "$CONFIG_FILE"

echo "[entrypoint] Config written to ${CONFIG_FILE}"
echo "[entrypoint] Starting xray-core..."

# Execute xray with the generated config
exec /usr/local/bin/xray run -config "$CONFIG_FILE"
