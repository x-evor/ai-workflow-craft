#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"

echo "repo_root=$root"

if git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  remote="$(git -C "$root" remote get-url origin 2>/dev/null || true)"
  if [[ -n "$remote" ]]; then
    web_url="$(printf '%s' "$remote" | sed -E 's#git@github.com:([^/]+)/(.+)\.git#https://github.com/\1/\2#; s#https://github.com/([^/]+)/(.+)\.git#https://github.com/\1/\2#')"
    echo "origin=$remote"
    echo "github_web=$web_url"
    echo "latest_release=${web_url}/releases/latest"
  fi
fi

if [[ -d "$root/images" ]]; then
  echo "images:"
  find "$root/images" -maxdepth 2 -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
    | sort \
    | head -n 5
fi

if [[ -d "$root/docs" ]]; then
  echo "docs:"
  find "$root/docs" -maxdepth 2 -type f -name '*.md' | sort | head -n 12
fi
