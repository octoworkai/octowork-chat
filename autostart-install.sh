#!/bin/bash
# OctoWork Bot聊天管理器 - 自动启动安装脚本
# 用法: ./tools/autostart-install.sh [安装目录]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${1:-$(pwd)}"
APP_NAME="OctoWork Bot Chat Manager"

echo ""
echo "🔧 $APP_NAME 自动启动配置"
echo ""

# 检测操作系统
OS="$(uname -s)"
case "$OS" in
    Darwin)
        echo "🍎 检测到 macOS"
        configure_macos_autostart
        ;;
    Linux)
        echo "🐧 检测到 Linux"
        configure_linux_autostart
        ;;
    MINGW*|CYGWIN*|MSYS*)
        echo "🪟 检测到 Windows (Git Bash/Cygwin)"
        echo "   Windows 自动启动配置需要管理员权限"
        echo "   请手动配置计划任务或启动文件夹"
        configure_windows_autostart
        ;;
    *)
        echo "❓ 未知操作系统: $OS"
        echo "   自动启动配置需要手动完成"
        exit 1
        ;;
esac

echo ""
echo "✅ 自动启动配置完成！"
echo "   $APP_NAME 将在系统启动时自动运行"

# ==================== macOS 配置 ====================
configure_macos_autostart() {
    local LAUNCH_AGENT_DIR="$HOME/Library/LaunchAgents"
    local PLIST_FILE="$LAUNCH_AGENT_DIR/com.octowork.bot-chat-manager.plist"
    local START_SCRIPT="$INSTALL_DIR/start.sh"
    
    if [ ! -f "$START_SCRIPT" ]; then
        echo "❌ 找不到启动脚本: $START_SCRIPT"
        exit 1
    fi
    
    echo "  配置 LaunchAgent..."
    
    # 创建 LaunchAgents 目录
    mkdir -p "$LAUNCH_AGENT_DIR"
    
    # 生成 plist 文件
    cat > "$PLIST_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.octowork.bot-chat-manager</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$START_SCRIPT</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>
    <key>StandardOutPath</key>
    <string>$INSTALL_DIR/logs/launchd.log</string>
    <key>StandardErrorPath</key>
    <string>$INSTALL_DIR/logs/launchd-error.log</string>
    <!-- 每天早上8点重启一次（用户上班时间） -->
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>8</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
EOF
    
    echo "  LaunchAgent 配置已保存: $PLIST_FILE"
    
    # 创建日志目录
    mkdir -p "$INSTALL_DIR/logs"
    
    # 加载 LaunchAgent
    launchctl unload "$PLIST_FILE" 2>/dev/null
    launchctl load "$PLIST_FILE"
    
    if [ $? -eq 0 ]; then
        echo "✅ macOS 自动启动配置成功！"
        echo "   下次开机时将自动启动 $APP_NAME"
        echo "   每天早上8点会自动重启服务（防止内存泄漏）"
    else
        echo "⚠️  LaunchAgent 加载失败，可能需要手动加载"
        echo "   手动加载命令: launchctl load $PLIST_FILE"
    fi
}

# ==================== Linux 配置 ====================
configure_linux_autostart() {
    local SYSTEMD_USER_DIR="$HOME/.config/systemd/user"
    local SERVICE_FILE="$SYSTEMD_USER_DIR/bot-chat-manager.service"
    local START_SCRIPT="$INSTALL_DIR/start.sh"
    
    if [ ! -f "$START_SCRIPT" ]; then
        echo "❌ 找不到启动脚本: $START_SCRIPT"
        exit 1
    fi
    
    echo "  配置 systemd 用户服务..."
    
    # 创建 systemd 用户目录
    mkdir -p "$SYSTEMD_USER_DIR"
    
    # 生成 service 文件
    cat > "$SERVICE_FILE" << EOF
[Unit]
Description=OctoWork Bot Chat Manager
After=network.target

[Service]
Type=simple
WorkingDirectory=$INSTALL_DIR
ExecStart=/bin/bash $START_SCRIPT
Restart=always
RestartSec=60
User=$USER

# 每天重启一次
RuntimeMaxSec=86400

StandardOutput=file:$INSTALL_DIR/logs/systemd.log
StandardError=file:$INSTALL_DIR/logs/systemd-error.log

[Install]
WantedBy=default.target
EOF
    
    echo "  systemd 服务配置已保存: $SERVICE_FILE"
    
    # 创建日志目录
    mkdir -p "$INSTALL_DIR/logs"
    
    # 重新加载 systemd 并启用服务
    systemctl --user daemon-reload
    systemctl --user enable bot-chat-manager.service
    systemctl --user start bot-chat-manager.service
    
    if [ $? -eq 0 ]; then
        echo "✅ Linux 自动启动配置成功！"
        echo "   下次登录时将自动启动 $APP_NAME"
        echo "   服务会自动重启（防止崩溃）"
    else
        echo "⚠️  systemd 配置失败，可能需要手动配置"
        echo "   请检查 systemd 状态: systemctl --user status bot-chat-manager.service"
    fi
}

# ==================== Windows 配置 ====================
configure_windows_autostart() {
    echo "   Windows 自动启动配置指导:"
    echo ""
    echo "   1. 打开任务计划程序 (taskschd.msc)"
    echo "   2. 创建基本任务"
    echo "   3. 名称: OctoWork Bot Chat Manager"
    echo "   4. 触发器: 计算机启动时"
    echo "   5. 操作: 启动程序"
    echo "   6. 程序/脚本: bash"
    echo "   7. 参数: $INSTALL_DIR/start.sh"
    echo "   8. 完成"
    echo ""
    echo "   或手动将 start.sh 的快捷方式放入启动文件夹"
    echo "   Windows 启动文件夹: %APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"
    echo ""
}
