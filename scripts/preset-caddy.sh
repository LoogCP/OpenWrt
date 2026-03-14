#!/bin/bash
set -e

# 固定基础目录为当前目录下的 files（OpenWrt 编译暂存目录）
BASE_DIR="./files"

# 创建必要的子目录
mkdir -p "$BASE_DIR/usr/bin"
mkdir -p "$BASE_DIR/etc/caddy"
mkdir -p "$BASE_DIR/etc/init.d"

# 架构设置（可根据需要修改）
ARCH="amd64"

# 1. 下载并安装 caddy 二进制（从 GitHub Release）
DOWNLOAD_URL=$(curl -fsSL "https://api.github.com/repos/LoogCP/caddy/releases/latest" | grep "browser_download_url" | grep "linux-${ARCH}\.tar\.gz" | head -n1 | sed -E 's/.*"browser_download_url": "([^"]+)".*/\1/')
wget -qO- "$DOWNLOAD_URL" | tar -xz -C "$BASE_DIR/usr/bin" caddy
if [ ! -f "$BASE_DIR/usr/bin/caddy" ]; then
    echo "错误: 解压后未找到 caddy 二进制文件"
    exit 1
fi
chmod +x "$BASE_DIR/usr/bin/caddy"

# 2. 下载 Caddyfile 配置文件
wget -qO "$BASE_DIR/etc/caddy/Caddyfile" "https://raw.githubusercontent.com/LoogCP/caddy/main/Caddyfile"
if [ ! -f "$BASE_DIR/etc/caddy/Caddyfile" ]; then
    echo "错误: 下载 Caddyfile 失败"
    exit 1
fi

# 3. 下载 init 脚本
wget -qO "$BASE_DIR/etc/init.d/caddy" "https://raw.githubusercontent.com/LoogCP/caddy/main/caddy.init"
if [ ! -f "$BASE_DIR/etc/init.d/caddy" ]; then
    echo "错误: 下载 caddy.init 失败"
    exit 1
fi
chmod +x "$BASE_DIR/etc/init.d/caddy"

# 4. 下载 ubus 脚本
wget -qO "$BASE_DIR/etc/caddy/ubus.sh" "https://raw.githubusercontent.com/LoogCP/caddy/main/ubus.sh"
if [ ! -f "$BASE_DIR/etc/caddy/ubus.sh" ]; then
    echo "错误: 下载 ubus.sh 失败"
    exit 1
fi
chmod +x "$BASE_DIR/etc/caddy/ubus.sh"

echo "所有文件已成功放置到 $BASE_DIR 下"
