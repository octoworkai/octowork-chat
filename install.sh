#!/bin/bash
# OctoWork 聊天管理器 — 首次安装脚本
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/backend"
VERSION=$(cat "$SCRIPT_DIR/VERSION" 2>/dev/null || echo "unknown")

echo ""
echo "OctoWork 聊天管理器 v${VERSION} — 安装向导"
echo ""

# 1. 检查 Node.js
echo "[1/4] 检查 Node.js..."
if ! command -v node &>/dev/null; then
  echo "❌ 未检测到 Node.js"
  echo ""
  echo "请先安装 Node.js:"
  echo "  macOS:   brew install node"
  echo "  Ubuntu:  sudo apt install nodejs npm"
  echo "  Windows: https://nodejs.org/ 下载安装"
  echo ""
  echo "推荐版本: 18.x 或 20.x LTS"
  exit 1
fi

NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 16 ]; then
  echo "⚠️  Node.js 版本过低 ($(node -v))，建议升级到 18.x 或 20.x"
fi
echo "  Node.js $(node -v) — OK"

# 2. 检查数字公寓
echo ""
echo "[2/4] 检查数字公寓..."
WORKSPACE="${OCTOWORK_WORKSPACE:-$HOME/octowork}"
if [ ! -d "$WORKSPACE" ]; then
  echo "⚠️  数字公寓目录 $WORKSPACE 不存在"
  echo "   请先安装 OctoWork 数字公寓"
  exit 1
fi

if [ ! -f "$WORKSPACE/config/ai-directory.json" ]; then
  echo "⚠️  ai-directory.json 不存在，数字公寓可能未正确配置"
fi
echo "  数字公寓: $WORKSPACE — OK"

# 3. 安装后端依赖
echo ""
echo "[3/4] 安装后端依赖..."
cd "$BACKEND_DIR"
npm install --production
echo "  后端依赖安装完成"

# 4. 完成
echo ""
echo "[4/4] 安装完成！"
echo ""
echo "========================================================"
echo "  下一步操作:"
echo "========================================================"
echo ""
echo "  1. 启动程序:  cd $SCRIPT_DIR && ./start.sh"
echo ""
echo "  2. 首次启动会显示机器指纹"
echo "     将指纹发给管理员获取 license.key"
echo ""
echo "  3. 将 license.key 放到: $SCRIPT_DIR/license.key"
echo ""
echo "  4. 重新启动: ./start.sh"
echo ""
echo "  5. 打开浏览器: http://127.0.0.1:1314"
echo ""

# 询问是否配置自动启动
if [ -f "$SCRIPT_DIR/autostart-install.sh" ]; then
  echo ""
  echo "========================================================"
  echo "  可选: 配置自动启动（开机自启 + 每天自动重启）"
  echo "========================================================"
  echo ""
  echo "  是否配置自动启动？这样每次开机都会自动运行 Bot聊天管理器"
  echo "  并每天上午8点自动重启（防止内存泄漏）"
  echo ""
  read -p "  是否配置自动启动？(y/N): " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔧 配置自动启动..."
    "$SCRIPT_DIR/autostart-install.sh" "$SCRIPT_DIR"
  fi
else
  echo ""
  echo "💡 提示: 如需配置自动启动，请运行: ./autostart-install.sh"
fi
