---
name: xworkmate-acceptance
description: Validate release readiness for the Flutter project `xworkmate.svc.plus`. Use when Codex needs to run project-specific acceptance after UI, gateway runtime, settings, account, testing, packaging, or macOS/iOS delivery changes. This skill covers static analysis, unit/widget tests, serial macOS integration tests, macOS/iOS build checks, macOS DMG packaging and installation, and project-specific behavioral assertions such as `.env` being prefill-only and gateway configuration not being hardcoded.
---

# Xworkmate Acceptance

## Overview

Run the XWorkmate acceptance workflow from the repo root. Prefer repo-native commands and report concrete pass/fail results. Do not mark a check as passed if the runner hangs, the app cannot attach, or the behavior was only inferred.

If the diff touches auth, gateway runtime, `.env`, secure storage, native entitlements, packaging, or file attachments, apply `$xworkmate-secure-development` before final sign-off.

## Workflow

### 1. Confirm scope

Inspect the current diff and identify whether the change touches any of these acceptance-critical areas:

- `lib/features/assistant/`
- `lib/features/modules/`
- `lib/features/tasks/`
- `lib/features/settings/`
- `lib/features/account/`
- `lib/features/mobile/ios_mobile_shell.dart`
- `lib/runtime/`
- `lib/widgets/gateway_connect_dialog.dart`
- `lib/widgets/sidebar_navigation.dart`
- `macos/Runner/`
- `ios/Runner.xcodeproj/`

If the change touches any of these areas, run the full workflow below.

### 2. Run static analysis and unit/widget tests

Run:

```bash
flutter analyze
flutter test
```

Treat `flutter test` as the required baseline. It must cover runtime unit tests plus widget tests for the main UI surfaces.

### 3. Run macOS integration tests serially

Never batch the macOS integration files into one shared device-run. Run them one by one and clean up the app process between runs:

```bash
pkill -f '/build/macos/Build/Products/Debug/XWorkmate.app/Contents/MacOS/XWorkmate' || true
flutter test integration_test/desktop_navigation_flow_test.dart -d macos
pkill -f '/build/macos/Build/Products/Debug/XWorkmate.app/Contents/MacOS/XWorkmate' || true
flutter test integration_test/desktop_settings_flow_test.dart -d macos
```

If a case hangs in device-run without a concrete assertion failure, report it as `manual follow-up` instead of guessing.

### 4. Run build checks

Run:

```bash
flutter build macos
flutter build ios --simulator
```

If the user asked for packaging or installation, continue with:

```bash
make install-mac
```

This repo already provides `Makefile`, `scripts/package-flutter-mac-app.sh`, and `scripts/install-flutter-mac-dmg.sh`.

### 5. Enforce project-specific acceptance assertions

Verify these behaviors explicitly:

- `.env` is prefill-only for Settings -> Integrations -> Gateway. Do not hardcode gateway host, token, or passwords into Dart code.
- `.env` values must not auto-persist into settings and must not auto-connect the gateway.
- A manual gateway connect attempt must use the current token/password field values for the active handshake instead of depending on a secure-store readback.
- UI layout must remain unchanged; only functional wiring is allowed.
- Sidebar account area must not overflow on compact widths.
- Assistant must send real gateway attachments rather than filename placeholders.
- Modules / Tasks must use real gateway data flows for models, connectors, and cron jobs.
- iOS account page `保存本地入口` must save the current field controller values even if the user did not press return first.

When validating these assertions, inspect the corresponding implementation files directly instead of relying only on test output.

### 6. Handle manual fallback

If an automated check is blocked by host instability, leave a concrete manual path. For the current macOS settings-flow fallback, use:

1. Launch the macOS app.
2. Open `模块`.
3. Click `接入模块`.
4. In Settings, switch to `集成`.
5. Verify `网关连接` is visible.

### 7. Report format

Report results in three sections:

- `检查结果`: summarize the highest-signal behavior and any fixes applied
- `验收`: list each automated command and whether it passed
- `人工补测`: only include steps for checks that could not be executed reliably

Keep the report concrete. Include file paths for behavioral fixes when relevant.
