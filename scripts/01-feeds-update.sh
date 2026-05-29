#!/bin/bash
# ============================================
# 第三方插件管理 (重构版 - 解决冲突与失效地址)
# ============================================
set -e

# ============ 1. 基础 Feeds 配置 ============
# 说明：不再通过 src-git 添加单插件仓库，避免 feeds 解析错误。
# 仅保留多包综合仓库。
echo "📥 正在配置 Feeds 源..."

# 备份原配置
[ -f feeds.conf.default.bak ] || cp feeds.conf.default feeds.conf.default.bak

# 还原并追加（确保幂等性）
cp feeds.conf.default.bak feeds.conf.default
cat >> feeds.conf.default << 'EOF'

# ===== 自定义综合插件源 =====
# (目前 ImmortalWrt 官方 feeds 已包含大部分常用插件，如 aria2, ddns-go, openclash)
# 如果官方源版本较旧，可在此添加特定仓库，但建议优先使用官方源以保证依赖兼容性。
EOF

echo "✅ Feeds 源配置完成"

# ============ 2. 独立插件克隆 (package/custom) ============
# 说明：对于单包仓库或需要特定版本的插件，直接克隆到 package 目录。
echo "📥 正在克隆独立插件..."
mkdir -p package/custom

# 1. OpenClash (使用官方 dev 分支)
if [ ! -d "package/custom/openclash" ]; then
    git clone --depth=1 -b dev https://github.com/vernesong/OpenClash.git package/custom/openclash
fi

# 2. luci-theme-aurora (更新为 eamonxg 维护的新地址)
if [ ! -d "package/custom/luci-theme-aurora" ]; then
    git clone --depth=1 https://github.com/eamonxg/luci-theme-aurora.git package/custom/luci-theme-aurora
fi

# 3. luci-app-athena-led (雅典娜AX6600专属插件)
if [ ! -d "package/custom/luci-app-athena-led" ]; then
    git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led.git package/custom/luci-app-athena-led
    # 修正执行权限
    find package/custom/luci-app-athena-led -name "athena_led" -o -name "athena-led" | xargs chmod +x 2>/dev/null || true
fi

# 4. OpenList2 (sbwml 维护)
if [ ! -d "package/custom/luci-app-openlist2" ]; then
    git clone --depth=1 https://github.com/sbwml/luci-app-openlist2.git package/custom/luci-app-openlist2
fi

# 5. ddns-go (使用 iRis7656 维护版，不再使用失效的 sirpdboy 地址)
if [ ! -d "package/custom/luci-app-ddns-go" ]; then
    git clone --depth=1 https://github.com/iRis7656/luci-app-ddns-go.git package/custom/luci-app-ddns-go
fi

echo "✅ 独立插件处理完成"
