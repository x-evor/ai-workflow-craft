# External Validation

Use this reference when the user wants a real-world browsing check after local Tunnel Mode or Proxy Mode baseline checks already pass.

## Preconditions

- Complete the relevant local baseline first:
  Tunnel Mode or Proxy Mode must already meet the pass criteria in `macos-baseline.md`.
- Use the currently selected mode intentionally.
- If Tunnel Mode is under validation, ensure no competing System VPN is connected.
- Prefer a real browser session.
- If browser automation is available, use it for repeatable checks. If not, perform the checks manually and record what was visible.

## Browser Matrix

Prefer a fixed browser matrix so regressions are comparable across runs.

Validate these cases:

1. `Safari` + `https://www.google.com/`
2. `Safari` + `https://github.com/`
3. `Safari` + `https://openai.com/`
4. `Google Chrome` + `https://www.google.com/`
5. `Google Chrome` + `https://github.com/`
6. `Google Chrome` + `https://openai.com/`

For each case, record:

- final URL
- tab title
- whether the main landing page or app shell visibly loaded

## Minimum Pass Condition

For each browser and target pair:

- The page opens successfully without a browser error page.
- The main landing page, app shell, or sign-in screen finishes loading.
- Browser-visible readiness is present:
  page title resolves correctly, the main shell is rendered, and the tab does not remain on a connection error surface.

Do not require account-specific or destructive actions.
If the user is already signed in, it is enough to confirm that the main product shell is usable.
If the user is not signed in, it is enough to confirm that the sign-in or landing experience loads normally.

## Notes

- `openai.com` may return `HTTP 403` to command-line probes because of challenge behavior. Do not treat that alone as a Tunnel or Proxy failure if the browser page itself loads normally.
- `Chrome` is the more sensitive detector for Tunnel regressions involving HTTP/3 or QUIC behavior. If `Safari` passes but `Chrome` shows a connection-closed page for `google.com`, call that out explicitly.

## Mode-Specific Interpretation

### Tunnel Mode

Use this after `Xstream` is connected and the default route is on `utunN`.

Pass evidence:

- The benchmark page loads in the browser.
- System VPN remains connected during the check.
- No competing System VPN replaces the active session.

### Proxy Mode

Use this after local listeners and proxy settings match the expected proxy path.

Pass evidence:

- The benchmark page loads in the browser through the active proxy configuration.
- Local listeners on `1080` or `1081` remain present during the check.
- If Xstream manages system proxies, proxy settings still match the selected proxy mode.

## Reporting Template

For each case, report:

- browser
- target URL
- active mode
- page loaded or failed
- final URL
- tab title
- visible readiness evidence
- blocking symptom if failed

Example:

- `Chrome`, `https://www.google.com/`, `Tunnel Mode`, loaded, final URL `https://www.google.com/`, title `www.google.com`, landing page visible
- `Safari`, `https://openai.com/`, `Tunnel Mode`, loaded, final URL `https://openai.com/zh-Hans-CN/`, title `OpenAI`, landing page visible
