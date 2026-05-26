#!/bin/bash
# ============================================
# 编译前定制:IP、时区、移除冗余插件
# ============================================
set -e

echo "🔧 修改默认 IP 为 10.1.1.1..."
sed -i 's/192.168.1.1/10.1.1.1/g' package/base-files/files/bin/config_generate

echo "🔧 设置默认时区为 Asia/Shanghai..."
sed -i "s/'UTC'/'CST-8'/g" package/base-files/files/bin/config_generate
sed -i "s/'Etc\/UTC'/'Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

echo "🚫 强制移除不需要的科学上网插件..."
# 移除 passwall / passwall2 / ssr-plus / bypass 等
REMOVE_PKGS=(
    "luci-app-passwall"
    "luci-app-passwall2"
    "luci-app-ssr-plus"
    "luci-app-bypass"
    "luci-app-vssr"
    "luci-app-v2ray-server"
    "luci-app-trojan-server"
)

for pkg in "${REMOVE_PKGS[@]}"; do
    # 在 .config 中显式禁用
    sed -i "/CONFIG_PACKAGE_${pkg}=/d" .config
    echo "# CONFIG_PACKAGE_${pkg} is not set" >> .config

    # 删除源码目录(防止依赖被自动拉入)
    find package/ feeds/ -type d -name "${pkg}" -exec rm -rf {} + 2>/dev/null || true
done

echo "✅ 编译前预处理完成"
