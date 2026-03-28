#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"

if [[ ! -d "$root/images" ]]; then
  exit 0
fi

find "$root/images" -maxdepth 2 -type f \
  \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
  | sort \
  | head -n 3
