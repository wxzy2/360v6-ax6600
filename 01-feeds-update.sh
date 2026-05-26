#!/bin/bash
# ============================================
# 添加第三方插件源 (原作者仓库)
# ============================================
set -e

echo "📥 添加第三方 feeds 源..."

# 备份原配置
cp feeds.conf.default feeds.conf.default.bak

# 追加第三方源(原作者仓库)
cat >> feeds.conf.default << 'EOF'

# ===== 第三方插件源 =====
# OpenClash - 原作者: vernesong
src-git openclash https://github.com/vernesong/OpenClash.git;dev

# luci-app-homeproxy - 原作者: immortalwrt 官方维护
# (homeproxy 已在 immortalwrt 官方 feeds,无需额外添加)

# ddns-go - 原作者: sirpdboy 维护的 luci 版本
src-git ddnsgo https://github.com/sirpdboy/luci-app-ddns-go.git

# luci-theme-aurora - 原作者: rosywrt
src-git aurora https://github.com/rosywrt/luci-theme-aurora.git

# luci-app-athena-led - 原作者: NONGFAH (雅典娜AX6600专属)
src-git athena_led https://github.com/NONGFAH/luci-app-athena-led.git

# aria2 - 原作者: 官方 luci 已有,使用扩展版
src-git aria2 https://github.com/sirpdboy/luci-app-aria2.git

# OpenList2 - 原作者: sbwml
src-git openlist2 https://github.com/sbwml/luci-app-openlist2.git

EOF

echo "✅ feeds 源添加完成"

# ============ 拷贝单独插件到 package 目录 ============
mkdir -p package/custom

# OpenClash
if [ ! -d "package/custom/openclash" ]; then
    git clone --depth=1 -b dev https://github.com/vernesong/OpenClash.git package/custom/openclash
fi

# luci-theme-aurora
if [ ! -d "package/custom/luci-theme-aurora" ]; then
    git clone --depth=1 https://github.com/rosywrt/luci-theme-aurora.git package/custom/luci-theme-aurora
fi

# ddns-go
if [ ! -d "package/custom/luci-app-ddns-go" ]; then
    git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go.git package/custom/luci-app-ddns-go
fi

# luci-app-athena-led
if [ ! -d "package/custom/luci-app-athena-led" ]; then
    git clone --depth=1 https://github.com/NONGFAH/luci-app-athena-led.git package/custom/luci-app-athena-led
    chmod +x package/custom/luci-app-athena-led/luci-app-athena-led/root/etc/init.d/athena_led 2>/dev/null || true
    chmod +x package/custom/luci-app-athena-led/luci-app-athena-led/root/usr/sbin/athena-led 2>/dev/null || true
fi

# OpenList2
if [ ! -d "package/custom/luci-app-openlist2" ]; then
    git clone --depth=1 https://github.com/sbwml/luci-app-openlist2.git package/custom/luci-app-openlist2
fi

echo "✅ 第三方插件克隆完成"