#!/bin/bash
set -e
ARCH="amd64"
OUTPUT_DIR="${1:-files/usr/bin/caddy}"
mkdir -p "$OUTPUT_DIR"

DOWNLOAD_URL=$(curl -fsSL "https://api.github.com/repos/LoogCP/caddy/releases/latest" | grep "browser_download_url" | grep "linux-${ARCH}\.tar\.gz" | head -n1 | sed -E 's/.*"browser_download_url": "([^"]+)".*/\1/')

wget -qO- "$DOWNLOAD_URL" | tar -xz -C "$OUTPUT_DIR" caddy

if [ ! -f "$OUTPUT_DIR/caddy" ]; then
    echo "错误: 解压后未找到 caddy 二进制文件"
    exit 1
fi

chmod +x "$OUTPUT_DIR/caddy"
