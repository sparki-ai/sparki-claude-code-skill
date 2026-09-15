#!/usr/bin/env bash
# Install / upgrade the sparki-cli engine (cloud API client; no local rendering).
set -euo pipefail

if ! command -v uv >/dev/null 2>&1; then
  echo "error: 'uv' is required. Install with 'brew install uv' or" >&2
  echo "  curl -LsSf https://astral.sh/uv/install.sh | sh" >&2
  exit 1
fi

echo "Installing / upgrading sparki-cli..."
uv tool install --upgrade sparki-cli

echo
sparki doctor || {
  echo >&2
  echo "doctor reported issues. If api_key is missing:" >&2
  echo "  sparki setup --api-key <YOUR_KEY>   # get one at https://sparki.io/claude-code-skill" >&2
  echo "or export SPARKI_API_KEY in your environment." >&2
  exit 1
}
echo
echo "sparki-cli ready. 🎬"
