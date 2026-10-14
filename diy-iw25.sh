#!/bin/bash

#添加small源
sed -i '1i src-git small https://github.com/kenzok8/small' feeds.conf.default

# 修改默认IP
sed -i 's/192.168.1.1/10.10.1.1/g' package/base-files/files/bin/config_generate

# 更改默认 Shell 为 fish
sed -i 's/\/bin\/ash/\/usr\/bin\/fish/g' package/base-files/files/etc/passwd


# Themes
git clone --depth=1 -b master https://github.com/kiddin9/luci-theme-edge package/luci-theme-edge

# x86 型号只显示 CPU 型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/emortal/autocore/files/x86/autocore

# 修改本地时间格式
sed -i 's/os.date()/os.date("%a %Y-%m-%d %H:%M:%S")/g' package/emortal/autocore/files/*/index.htm

# 修改版本为编译日期
date_version=$(date +"%y.%m.%d")
orig_version=$(cat "package/emortal/default-settings/files/99-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
sed -i "s/${orig_version}/R${date_version} by LoogCP/g" package/emortal/default-settings/files/99-default-settings


./scripts/feeds update -a
./scripts/feeds install -a
./scripts/feeds install  -f -a -p small

