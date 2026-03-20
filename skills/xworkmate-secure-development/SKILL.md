---
name: xworkmate-secure-development
description: Enforce secure development and secure coding rules for the Flutter project `XWorkmate.svc.plus`. Use when Codex changes gateway auth, secrets, `.env` handling, secure storage, networking, file upload, native entitlements, packaging, or release-critical settings, or when the user asks for security rules during implementation.
---

# Xworkmate Secure Development

## Overview

Use this skill before changing any auth, secret, network, storage, or native-app surface in `XWorkmate.svc.plus`. The goal is to keep UI behavior intact while preventing hardcoded configuration, accidental secret persistence, unsafe transport downgrades, over-broad entitlements, and missing regression coverage.

If the repo contains `/Users/shenlan/workspaces/cloud-neutral-toolkit/XWorkmate.svc.plus/docs/security/secure-development-rules.md`, read that file and align the implementation with it.

## When To Apply

Apply this skill when the diff touches any of these areas:

- `lib/runtime/`
- `lib/features/settings/`
- `lib/features/secrets/`
- `lib/features/assistant/`
- `lib/widgets/gateway_connect_dialog.dart`
- `.env` parsing or bootstrap code
- `ios/Runner/`, `macos/Runner/`, entitlement files, or packaging scripts
- any code that reads tokens, passwords, API keys, hostnames, ports, TLS flags, uploaded files, or external URLs

## Workflow

### 1. Map the trust boundary

Identify which inputs are untrusted and where they cross into privileged behavior:

- user-entered gateway host / port / TLS / token / password
- `.env` bootstrap values
- secure-store values
- file attachments selected by the user
- native capabilities such as network, filesystem, and app sandbox entitlements

Do not start coding until the boundary is explicit.

### 2. Apply the coding rules

Enforce these rules during implementation:

- Never hardcode real tokens, passwords, API keys, hostnames, ports, or TLS choices into Dart, Swift, Objective-C, Xcode project files, or tests.
- `.env` is prefill-only for Settings -> Integrations -> Gateway. It must not silently become the persisted source of truth and must not auto-connect the gateway.
- Long-lived secrets belong in secure storage, not `SharedPreferences`, plain JSON, logs, screenshots, or fixture files.
- For an immediate user-initiated gateway connect action, the current form input may be used directly for that handshake instead of depending on a secure-store round-trip. Persistence is separate from the active connect attempt.
- Do not print full secret values in logs, exceptions, banners, debug output, or test snapshots. Redact or mask them.
- Only allow non-TLS transport for explicit loopback/local mode. Remote hosts must keep TLS explicit and intentional.
- File uploads and attachments must be user-selected and scope-limited. Do not read or exfiltrate workspace files implicitly.
- New entitlements or native permissions must be least-privilege and justified by an actual feature.

### 3. Add regression coverage

When the change affects auth, secrets, or trust boundaries, add or update tests that cover:

- happy-path connect/send behavior
- missing or invalid auth behavior
- persistence boundaries, especially `.env` prefill vs saved settings
- UI submission behavior when the user edits a field but has not triggered focus-loss or submit events

Prefer unit and widget tests first. Run device integration tests serially if needed.

### 4. Run the security gate

From the repo root, use at least these checks:

```bash
flutter analyze
flutter test
rg -n "\\.env|RuntimeBootstrapConfig|saveGatewayToken|saveGatewayPassword|FlutterSecureStorage|SharedPreferences" lib test
rg -n "token|password|secret|api[_-]?key" lib test ios macos --glob '!**/Pods/**' --glob '!**/*.g.dart'
```

Treat the `rg` output as a review list, not an automatic failure. The goal is to confirm that every secret-related touchpoint is intentional and properly handled.

If macOS integration is needed, run it one file at a time:

```bash
pkill -f '/build/macos/Build/Products/Debug/XWorkmate.app/Contents/MacOS/XWorkmate' || true
flutter test integration_test/desktop_navigation_flow_test.dart -d macos
pkill -f '/build/macos/Build/Products/Debug/XWorkmate.app/Contents/MacOS/XWorkmate' || true
flutter test integration_test/desktop_settings_flow_test.dart -d macos
```

### 5. Report the outcome

When reporting, call out:

- which trust boundary changed
- which security-sensitive files were touched
- what prevents hardcoding or secret leakage now
- what automated coverage ran
- what remains manual, if any
