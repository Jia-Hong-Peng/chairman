#!/bin/bash
# chairman 安裝 / 更新腳本
# 用法：bash install.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$HOME/.claude/skills/chairman"
VERSION=$(grep '^version:' "$REPO_DIR/SKILL.md" 2>/dev/null | awk '{print $2}' | tr -d "'\"")
VERSION_FILE="$SKILL_DIR/.chairman-version"

mkdir -p "$SKILL_DIR/references"

# 判斷是全新安裝還是更新
IS_UPDATE=false
if [ -f "$VERSION_FILE" ]; then
  INSTALLED_VER=$(cat "$VERSION_FILE" 2>/dev/null)
  if [ "$INSTALLED_VER" = "$VERSION" ]; then
    echo "✓ chairman v$VERSION 已是最新版本，無需更新"
    exit 0
  fi
  echo "↑ 從 v$INSTALLED_VER 更新至 v$VERSION（公司資料保留完整）"
  IS_UPDATE=true
else
  echo "→ 全新安裝 chairman v$VERSION"
fi

# 複製技能主文件
cp "$REPO_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"

# 複製角色庫到 references/roles/
if [ -d "$REPO_DIR/references/roles" ]; then
  rm -rf "$SKILL_DIR/references/roles"
  cp -r "$REPO_DIR/references/roles" "$SKILL_DIR/references/roles"
  ROLE_COUNT=$(find "$SKILL_DIR/references/roles" -name "*.md" | grep -v "CATALOG" | wc -l | tr -d ' ')
  echo "✓ 角色庫已安裝：$SKILL_DIR/references/roles（$ROLE_COUNT 個角色文件）"
else
  echo "⚠️  references/roles/ 資料夾不存在，請確認 repo 完整"
  exit 1
fi

# 複製文件模板到 references/templates/
if [ -d "$REPO_DIR/references/templates" ]; then
  rm -rf "$SKILL_DIR/references/templates"
  cp -r "$REPO_DIR/references/templates" "$SKILL_DIR/references/templates"
  TMPL_COUNT=$(find "$SKILL_DIR/references/templates" -name "*.md" | wc -l | tr -d ' ')
  echo "✓ 文件模板已安裝：$SKILL_DIR/references/templates（$TMPL_COUNT 個模板）"
fi

# 複製 principles
if [ -f "$REPO_DIR/references/principles.md" ]; then
  cp "$REPO_DIR/references/principles.md" "$SKILL_DIR/references/principles.md"
fi

# 寫入版本標記
echo "$VERSION" > "$VERSION_FILE"

echo "✓ 技能主文件：$SKILL_DIR/SKILL.md"
if [ "$IS_UPDATE" = "true" ]; then
  echo "✓ 更新完成 v$VERSION — 重新啟動 Claude Code 後生效（~/.ptd/ 公司資料未異動）"
else
  echo "✓ 安裝完成 v$VERSION — 重新啟動 Claude Code 後輸入 /chairman 即可使用"
fi
