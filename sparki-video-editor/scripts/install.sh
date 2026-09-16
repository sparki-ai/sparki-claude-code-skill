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
echo "Verifying the CLI executable..."
sparki --help >/dev/null
echo
echo "sparki-cli installed. Configure an API key, then verify the connection:"
echo "  sparki setup --api-key <YOUR_KEY> --channel claude"
echo "  sparki doctor --channel claude"
