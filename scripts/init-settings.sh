#!/bin/bash

# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'
uci commit luci
# 禁用 uhttpd 服务
# 停止服务（如果正在运行）
/etc/init.d/uhttpd stop 2>/dev/null
# 关闭开机自启
/etc/init.d/uhttpd disable

# 通过 UCI 禁用 uhttpd（可选，确保配置不冲突）
# 将 uhttpd 主实例的监听端口改为非标准或直接禁用
uci set uhttpd.main.listen_http='' # 改为其他端口或空值
uci set uhttpd.main.listen_https=''  # 改为其他端口或空值
# 或者直接禁用整个服务（如果有 enable 选项）
# uci set uhttpd.main.enable='0'

# 提交 uhttpd 的 UCI 变更
uci commit uhttpd

# 启用 Caddy 服务
# 如果 Caddy 有 UCI 配置，可以在这里设置
# 例如：uci set caddy.@caddy[0].enabled='1'
# 假设 Caddy 的 init 脚本支持 enable 命令
if [ -x /etc/init.d/caddy ]; then
    # 停止可能运行的旧实例（如果有）
    /etc/init.d/caddy stop 2>/dev/null
    # 开启开机自启
    /etc/init.d/caddy enable
    # 启动服务
    /etc/init.d/caddy start
fi

uci commit
# Disable IPV6 ula prefix
# sed -i 's/^[^#].*option ula/#&/' /etc/config/network

# Check file system during boot
# uci set fstab.@global[0].check_fs=1
# uci commit fstab

exit 0
