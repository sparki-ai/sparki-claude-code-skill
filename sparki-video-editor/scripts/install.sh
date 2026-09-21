#!/usr/bin/env bash
# Install / upgrade the sparki-cli engine (cloud API client; no local rendering).
set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
  echo "error: 'uv' is required. Install it with a trusted package manager or" >&2
  echo "  follow https://docs.astral.sh/uv/getting-started/installation/" >&2
  exit 1
fi

echo "Installing / upgrading sparki-cli..."
uv tool install --upgrade sparki-cli

echo
echo "Verifying the CLI executable..."
if command -v sparki >/dev/null 2>&1; then
  sparki_command=(sparki)
else
  sparki_command=(uv tool run --from sparki-cli sparki)
fi
"${sparki_command[@]}" --help >/dev/null
echo
echo "sparki-cli installed. Connect and verify the account with:"
printf '  %s connect --channel claude --timeout 540\n' "${sparki_command[*]}"
