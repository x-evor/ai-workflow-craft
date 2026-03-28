---
name: readme-template-pack
description: Build a minimal, clear project README template with English-first output, optional Chinese bilingual mode, a short project intro, TL;DR quick start, a download matrix, image snapshots from `images/`, and learn-more links from `docs/`.
---

# README Template Pack

## Overview

Create a concise project README that works as a front page, not a full manual.
Default to English. Switch to bilingual English/Chinese only when the user asks for Chinese, bilingual output, or the repository clearly needs both.

The standard output order is:

1. `Project`
2. `TL;DR`
3. `Downloads`
4. `Snapshots`
5. `Learn More`

Keep the README short. Push details into `docs/`.

## Workflow

1. Detect repository inputs first.
- Check whether root `README.md` already exists and whether it should be replaced or updated.
- Detect GitHub remote URL when available.
- Detect `images/` and list suitable screenshot files.
- Detect `docs/` and pick the most useful entry points.

2. Decide language mode.
- Default to English.
- Use bilingual mode only when the user explicitly asks for Chinese or bilingual output.
- In bilingual mode, keep English first and Chinese second.

3. Draft the five sections.
- `Project`: 2 to 4 lines. Explain what the project is and who it is for.
- `TL;DR`: 3 to 5 commands max. Prefer install, run, test, and one release/build command when relevant.
- `Downloads`: use a compact matrix. Prefer GitHub `releases/latest` when a GitHub repo exists.
- `Snapshots`: render images from `images/` with short captions only.
- `Learn More`: link to a small set of docs entry points. Do not dump the entire docs tree.

4. Keep the document minimal.
- Avoid repeating long release notes, architecture docs, or changelog content.
- Avoid marketing-heavy prose.
- Avoid giant badge walls.
- Avoid more than one short paragraph per section unless the user asks for more detail.

5. Finalize.
- Preserve existing high-value repository wording when it is already good.
- Prefer Markdown tables only for the download matrix.
- Prefer relative image paths in generated README content.

## Output Rules

- English-first by default.
- Chinese is optional, not automatic.
- Headings should be short and predictable.
- Prefer direct verbs and plain wording.
- If a section has no data, omit it instead of adding placeholders unless the user explicitly wants a template skeleton.

## Recommended Assets

- English template: `assets/templates/README.en.md`
- Bilingual template: `assets/templates/README.bilingual.md`
- Image collector: `scripts/collect_showcase_images.sh`
- Docs collector: `scripts/detect_readme_inputs.sh`

## Detection Notes

- When a GitHub remote exists, normalize SSH or HTTPS remotes into the web URL and use:
  `https://github.com/<owner>/<repo>/releases/latest`
- For snapshots, prefer 1 to 3 images from `images/`.
- For learn-more links, prefer overview docs, release notes, roadmap, deployment, or planning docs.

## Do Not

- Do not turn the README into a full setup manual.
- Do not include every document under `docs/`.
- Do not hardcode unavailable store links unless the user gave them.
- Do not assume bilingual output when not requested.
