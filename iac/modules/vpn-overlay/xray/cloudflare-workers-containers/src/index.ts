/**
 * Cloudflare Worker — HTTP Gateway for Xray XHTTP Container
 *
 * This Worker receives all inbound HTTPS requests from clients and forwards
 * them to the Xray-core Container instance running XHTTP transport.
 *
 * Architecture:
 *   Client → Cloudflare Edge (this Worker) → Container (Xray-core) → Internet
 */

import { Container } from 'cloudflare:workers';

// ── Types ──────────────────────────────────────────────────────────────────

interface Env {
    XRAY_CONTAINER: DurableObjectNamespace;
    XRAY_UUID?: string;
    XRAY_PATH?: string;
    XRAY_LOG_LEVEL?: string;
}

// ── Container Class ────────────────────────────────────────────────────────

/**
 * XrayContainer — runs xray-core with XHTTP transport inside a
 * Cloudflare Container (backed by a Durable Object).
 *
 * - defaultPort: the port Xray listens on inside the container (must match
 *   the inbound port in xray-server-config.json).
 * - sleepAfter: idle timeout — container sleeps to save billing.
 * - envVars: injected into the container process; docker-entrypoint.sh
 *   uses these to render the Xray config via jq.
 */
export class XrayContainer extends Container {
    defaultPort = 8080;
    sleepAfter = '120s';

    // Static defaults — XRAY_UUID gets its real value from the
    // Worker secret, which is forwarded by the DO binding automatically.
    envVars = {
        XRAY_UUID: '',
        XRAY_PATH: '/xhttp',
        XRAY_LOG_LEVEL: 'warning',
    };

    override onStart(): void {
        console.log('[XrayContainer] Container started successfully');
    }

    override onStop(): void {
        console.log('[XrayContainer] Container stopped');
    }

    override onError(error: unknown): void {
        console.error('[XrayContainer] Container error:', error);
    }
}

// ── Helper: Pick a random container from a pool ────────────────────────────

function getRandomContainer(
    ns: DurableObjectNamespace,
    poolSize: number,
): DurableObjectStub {
    const index = Math.floor(Math.random() * poolSize);
    const id = ns.idFromName(`xray-instance-${index}`);
    return ns.get(id);
}

// ── Worker Fetch Handler ───────────────────────────────────────────────────

export default {
    async fetch(request: Request, env: Env): Promise<Response> {
        const url = new URL(request.url);
        const pathname = url.pathname;

        // Health check endpoint (bypass container)
        if (pathname === '/healthz' || pathname === '/health') {
            return new Response(
                JSON.stringify({
                    status: 'ok',
                    service: 'hk-xhttp-svc-plus',
                    timestamp: new Date().toISOString(),
                }),
                {
                    headers: { 'Content-Type': 'application/json' },
                },
            );
        }

        // Status endpoint — returns worker metadata (bypass container)
        if (pathname === '/__status') {
            return new Response(
                JSON.stringify({
                    service: 'hk-xhttp-svc-plus',
                    transport: 'xhttp',
                    path: env.XRAY_PATH ?? '/xhttp',
                    note: 'Xray XHTTP on Cloudflare Workers Containers',
                }),
                {
                    headers: { 'Content-Type': 'application/json' },
                },
            );
        }

        // All other requests → forward to Xray container
        // Load-balance across a small pool for better availability
        try {
            const container = getRandomContainer(env.XRAY_CONTAINER, 3);
            return await container.fetch(request);
        } catch (err) {
            console.error('[Worker] Error forwarding to container:', err);
            return new Response('Service temporarily unavailable', {
                status: 503,
                headers: {
                    'Retry-After': '10',
                    'Content-Type': 'text/plain',
                },
            });
        }
    },
};
