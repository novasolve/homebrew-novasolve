#!/bin/bash
# Fallback installation script for Nova
# Usage: curl -fsSL https://joinnova.com/install.sh | bash

set -euo pipefail

NOVA_VERSION="${NOVA_VERSION:-1.0.0}"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

# Detect OS and architecture
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Construct download URL
BINARY_NAME="nova-${NOVA_VERSION}-${OS}-${ARCH}"
DOWNLOAD_URL="https://github.com/novasolve/homebrew-novasolve/releases/download/v${NOVA_VERSION}/${BINARY_NAME}.tar.gz"

echo "Installing Nova v${NOVA_VERSION} for ${OS}/${ARCH}..."

# Create temp directory
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

# Download and extract
echo "Downloading from: $DOWNLOAD_URL"
curl -fsSL "$DOWNLOAD_URL" | tar -xz -C "$TEMP_DIR"

# Install binary
echo "Installing to: $INSTALL_DIR/nova"
sudo install -m 755 "$TEMP_DIR/nova" "$INSTALL_DIR/nova"

# Verify installation
if command -v nova >/dev/null 2>&1; then
    echo "✅ Nova installed successfully!"
    nova --version
    
    # Send telemetry ping (if endpoint is set)
    if [ -n "${NOVA_TELEMETRY_ENDPOINT:-}" ]; then
        curl -X POST "${NOVA_TELEMETRY_ENDPOINT}/install_ok" \
            -H "Content-Type: application/json" \
            -d "{
                \"method\": \"curl\",
                \"version\": \"${NOVA_VERSION}\",
                \"os\": \"${OS}\",
                \"arch\": \"${ARCH}\"
            }" 2>/dev/null || true
    fi
else
    echo "❌ Installation failed. Please check the error messages above."
    exit 1
fi

echo ""
echo "To get started, run: nova --help" 