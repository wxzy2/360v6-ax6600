#!/bin/bash
# ============================================
# 检测最终固件内包含的插件,生成清单
# ============================================
set -e

DEVICE=$1
BIN_DIR=$(find bin/targets -mindepth 2 -maxdepth 2 -type d | head -n1)

echo "🔍 检测固件中包含的插件..."

cd "$BIN_DIR"
MANIFEST=$(ls *.manifest 2>/dev/null | head -n1)

cd $GITHUB_WORKSPACE/immortalwrt

cat > plugins-list.md << EOF
## 📦 ${DEVICE} 固件信息

- **编译时间**: $(date '+%Y-%m-%d %H:%M:%S')
- **默认 IP**: \`10.1.1.1\`
- **默认时区**: \`Asia/Shanghai\`
- **Web 服务**: \`nginx\` (已替换 uhttpd)
- **内核版本**: $(grep -oP 'CONFIG_LINUX_\K[\d_]+' .config | head -n1 | tr '_' '.')

---

## 🎯 LuCI 插件清单

| 插件名 | 版本 |
|--------|------|
EOF

if [ -n "$MANIFEST" ] && [ -f "$BIN_DIR/$MANIFEST" ]; then
    grep -E "^luci-app-|^luci-theme-" "$BIN_DIR/$MANIFEST" | \
        awk '{printf "| `%s` | %s |\n", $1, $2}' >> plugins-list.md
fi

cat >> plugins-list.md << EOF

---

## 📂 完整包清单

<details>
<summary>点击展开查看所有已安装包</summary>

\`\`\`
$(cat "$BIN_DIR/$MANIFEST" 2>/dev/null || echo "manifest 未找到")
\`\`\`

</details>
EOF

echo "✅ 插件清单已生成: plugins-list.md"
cat plugins-list.md | head -n 30
