#!/bin/bash
# OctoWork 聊天管理器 — 一键启动
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/backend"
VERSION=$(cat "$SCRIPT_DIR/VERSION" 2>/dev/null || echo "unknown")

echo ""
echo "OctoWork 聊天管理器 v${VERSION} 启动中..."
echo ""

# 检查 Node.js
if ! command -v node &>/dev/null; then
  echo "❌ 未检测到 Node.js，请先安装: https://nodejs.org/"
  echo "   推荐版本: 18.x 或 20.x LTS"
  exit 1
fi
echo "  Node.js: $(node -v)"

# 检查 node_modules
if [ ! -d "$BACKEND_DIR/node_modules" ]; then
  echo ""
  echo "  首次运行，安装依赖..."
  cd "$BACKEND_DIR" && npm install --production
  echo "  依赖安装完成"
fi

# 检查数字公寓目录
WORKSPACE="${OCTOWORK_WORKSPACE:-$HOME/octowork}"
if [ ! -d "$WORKSPACE" ]; then
  echo ""
  echo "⚠️  数字公寓目录 $WORKSPACE 不存在"
  echo "   请确认 OctoWork 数字公寓已正确安装"
  exit 1
fi
echo "  数字公寓: $WORKSPACE"

# 检查并清理端口
PORT=1314
if command -v lsof &>/dev/null && lsof -i :$PORT -sTCP:LISTEN &>/dev/null; then
  echo ""
  echo "🔍 发现端口 $PORT 被占用，检查占用进程..."
  
  # 获取占用端口的进程信息
  LSOF_OUTPUT=$(lsof -i :$PORT -sTCP:LISTEN 2>/dev/null | grep LISTEN | head -5)
  if [ -n "$LSOF_OUTPUT" ]; then
    echo "  占用进程信息:"
    echo "$LSOF_OUTPUT" | sed 's/^/    /'
    
    # 提取进程ID
    PIDS=$(echo "$LSOF_OUTPUT" | awk '{print $2}' | sort -u)
    
    # 检查是否为node或已知服务进程
    CAN_CLEAN=1
    for PID in $PIDS; do
      PROCESS_INFO=$(ps -p $PID -o comm= 2>/dev/null || echo "unknown")
      if echo "$PROCESS_INFO" | grep -q -E "^(node|python|java|ruby|go|server|launcher)"; then
        echo "  检测到服务进程 $PROCESS_INFO (PID: $PID)，尝试清理..."
        kill $PID 2>/dev/null || kill -9 $PID 2>/dev/null
        echo "  ✅ 已清理进程 $PID"
      elif echo "$PROCESS_INFO" | grep -q -E "^(Microsoft|Google|Safari|firefox|chrome|edge)"; then
        echo "  ⚠️ 检测到浏览器进程 $PROCESS_INFO (PID: $PID)，可能是正常连接"
        CAN_CLEAN=0
      else
        echo "  ⚠️ 未知进程类型: $PROCESS_INFO (PID: $PID)，尝试清理..."
        kill $PID 2>/dev/null || kill -9 $PID 2>/dev/null
        if ps -p $PID >/dev/null 2>&1; then
          echo "  ❌ 无法清理未知进程 $PID，请手动处理"
          CAN_CLEAN=0
        else
          echo "  ✅ 已清理未知进程 $PID"
        fi
      fi
    done
    
    # 等待清理完成
    sleep 1
    
    # 再次检查端口
    if [ $CAN_CLEAN -eq 1 ] && ! lsof -i :$PORT -sTCP:LISTEN &>/dev/null; then
      echo "  ✅ 端口 $PORT 已释放，继续启动..."
    else
      echo ""
      echo "❌ 无法自动清理端口 $PORT"
      echo "   请手动停止占用端口的程序: lsof -i :$PORT"
      exit 1
    fi
  else
    echo "❌ 无法获取端口占用信息"
    echo "   请手动检查: lsof -i :$PORT"
    exit 1
  fi
fi

# 启动后端
echo ""
echo "  启动后端服务 (端口 $PORT)..."
cd "$BACKEND_DIR"
export OCTOWORK_WORKSPACE="$WORKSPACE"
node launcher.js &
BACKEND_PID=$!

# 等待后端就绪
echo "  等待后端就绪..."
READY=0
for i in $(seq 1 30); do
  if curl -s http://127.0.0.1:$PORT/api/system/version > /dev/null 2>&1; then
    READY=1
    break
  fi
  sleep 1
done

if [ $READY -eq 0 ]; then
  echo "❌ 后端启动超时，请检查日志"
  kill $BACKEND_PID 2>/dev/null
  exit 1
fi

echo ""
echo "========================================================"
echo "  OctoWork 聊天管理器已启动！"
echo "========================================================"
echo ""
echo "  访问地址: http://127.0.0.1:$PORT"
echo "  按 Ctrl+C 停止服务"
echo ""

# 等待退出信号
trap "echo ''; echo '正在停止服务...'; kill $BACKEND_PID 2>/dev/null; echo '已停止'; exit 0" INT TERM
wait $BACKEND_PID
