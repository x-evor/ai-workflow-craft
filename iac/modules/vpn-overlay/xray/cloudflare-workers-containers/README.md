# Xray XHTTP on Cloudflare Workers Containers

Deploy an Xray-core server with **XHTTP transport** on Cloudflare Workers Containers, taking advantage of Cloudflare's global edge network for network acceleration.

## Architecture

```
Client (Xstream App)
   │  vless + xhttp + tls
   ▼
Cloudflare Edge (Worker)
   │  HTTP forward
   ▼
Cloudflare Container (Xray-core)
   │  xhttp inbound → freedom outbound
   ▼
Internet
```

- **Worker**: Acts as the HTTP gateway, forwarding all requests to the Container.
- **Container**: Runs `xray-core` with XHTTP inbound, listening on port 8080.
- **Transport**: XHTTP — fully HTTP-compliant, works natively behind Cloudflare's CDN.

## Why XHTTP on Cloudflare Containers?

1. **HTTP-native**: Cloudflare Containers only support inbound HTTP — XHTTP is the ideal transport.
2. **CDN-backed**: Traffic appears as regular HTTPS to Cloudflare, providing natural network acceleration.
3. **Global edge**: Containers are deployed to Cloudflare's global network with automatic scaling.
4. **Serverless billing**: Pay only for active container runtime, containers sleep after idle timeout.

## Prerequisites

- Cloudflare account with Workers Containers access (open beta)
- Docker installed and running locally
- Node.js 18+ and npm
- Wrangler CLI (`npm install -g wrangler`)

## Quick Start

```bash
# 1. Install dependencies
npm install

# 2. Login to Cloudflare
npx wrangler login

# 3. Generate a UUID for the VLESS user
export XRAY_UUID=$(uuidgen | tr '[:upper:]' '[:lower:]')
echo "Your UUID: $XRAY_UUID"

# 4. Set it as a secret
npx wrangler secret put XRAY_UUID

# 5. Deploy
npx wrangler deploy
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `XRAY_UUID` | VLESS user UUID (set via `wrangler secret`) | **required** |
| `XRAY_PATH` | XHTTP request path | `/xhttp` |
| `XRAY_LOG_LEVEL` | Xray log level | `warning` |

### Wrangler Config (`wrangler.jsonc`)

Key settings:
- `max_instances`: Max concurrent container instances (default: 5)
- `sleepAfter`: Container idle timeout before sleep (default: `120s`)
- `defaultPort`: Internal container port (default: `8080`)

### Client Connection

Use the XHTTP transport in your Xstream client:

```
vless://<UUID>@<worker-subdomain>.workers.dev:443?type=xhttp&security=tls&sni=<worker-subdomain>.workers.dev&path=/xhttp&mode=auto#HK-XHTTP
```

Or with a custom domain:

```
vless://<UUID>@xhttp.svc.plus:443?type=xhttp&security=tls&sni=xhttp.svc.plus&path=/xhttp&mode=auto#HK-XHTTP
```

## Custom Domain

To use a custom domain instead of `*.workers.dev`:

1. Add the domain to your Cloudflare zone
2. Configure a route in `wrangler.jsonc`:
   ```json
   "routes": [
     { "pattern": "xhttp.svc.plus/*", "zone_name": "svc.plus" }
   ]
   ```
3. Redeploy: `npx wrangler deploy`

## File Structure

```
cloudflare-workers-containers/
├── README.md              # This file
├── wrangler.jsonc         # Cloudflare Workers + Containers config
├── package.json           # Node.js dependencies
├── tsconfig.json          # TypeScript config
├── Dockerfile             # Container image (xray-core)
├── docker-entrypoint.sh   # Container entrypoint script
├── xray-server-config.json# Xray server config template
└── src/
    └── index.ts           # Worker code (HTTP gateway)
```

## Monitoring

View container status and logs in the Cloudflare Dashboard:
- Workers & Pages → your worker → Containers tab
- Or via CLI: `npx wrangler tail`

## Troubleshooting

### Container not starting
- Check Docker is running locally (needed for build/push)
- Check container logs in Cloudflare Dashboard
- Ensure `XRAY_UUID` secret is set

### Connection refused
- Wait 2-3 minutes after first deploy for container cold start
- Verify the XHTTP path matches between client and server config
- Check that TLS SNI matches the worker domain

### Build failures
- Ensure Docker buildx supports `linux/amd64` platform
- Run `docker buildx create --use` if multi-platform builds fail
