#!/bin/sh
set -eu

# Prefer a locally installed command to avoid an unnecessary package download.
if command -v cute >/dev/null 2>&1; then
  exec cute "$@"
fi

if command -v npx >/dev/null 2>&1; then
  exec npx --yes @ras0q/cute "$@"
fi

printf '%s\n' 'cute: executable not found and npx is unavailable; install Cute or Node.js.' >&2
exit 127
