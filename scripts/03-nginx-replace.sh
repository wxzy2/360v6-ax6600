#!/bin/bash
# ============================================
# 强制使用 nginx 替代 uhttpd
# ============================================
set -e

echo "🔧 强制启用 nginx,禁用 uhttpd..."

# ============ 1. 在 .config 中显式声明 ============
# 禁用 uhttpd 全家桶
sed -i '/CONFIG_PACKAGE_uhttpd/d' .config
sed -i '/CONFIG_PACKAGE_luci-light/d' .config

cat >> .config << 'EOF'
# uhttpd disabled
# CONFIG_PACKAGE_uhttpd is not set
# CONFIG_PACKAGE_uhttpd-mod-ubus is not set
# CONFIG_PACKAGE_luci-light is not set

# nginx enabled
CONFIG_PACKAGE_luci-nginx=y
CONFIG_PACKAGE_nginx-ssl=y
CONFIG_PACKAGE_nginx-mod-luci=y
CONFIG_PACKAGE_nginx-mod-luci-ssl=y
CONFIG_PACKAGE_luci-ssl-nginx=y
EOF

# ============ 2. 修改 luci Makefile 默认依赖 ============
LUCI_MK="feeds/luci/collections/luci/Makefile"
if [ -f "$LUCI_MK" ]; then
    sed -i 's/+uhttpd/+nginx-ssl/g' "$LUCI_MK"
    sed -i 's/+luci-light/+luci-nginx/g' "$LUCI_MK"
fi

# ============ 3. 移除被自动拉入的 uhttpd 包 ============
# 防止某些插件强依赖 uhttpd
for f in $(grep -rl "+uhttpd" feeds/ package/ 2>/dev/null); do
    sed -i 's/+uhttpd/+nginx-ssl/g' "$f"
done

echo "✅ nginx 替换 uhttpd 完成"