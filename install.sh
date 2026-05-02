#!/bin/bash
# chairman 安裝腳本
# 用法：bash install.sh

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$HOME/.claude/skills/chairman"

mkdir -p "$SKILL_DIR/references"

# 複製技能主文件
cp "$REPO_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"

# 複製角色庫到 references/roles/（符合官方 skill 規範）
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

echo "✓ 技能主文件：$SKILL_DIR/SKILL.md"
echo "✓ 安裝完成 — 重新啟動 Claude Code 後輸入 /chairman 即可使用"
