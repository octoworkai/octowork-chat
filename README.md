# OctoWork Chat Manager

> 章鱼工作室 · AI 智能体工作台  
> 最新版本：v2026.06.14-1

---

## 下载安装

### macOS（Apple Silicon / M系列芯片）

**[⬇ 下载 mac-arm64 版本](https://gitee.com/octowork/octowork-chat/releases/download/v2026.06.14-1/octowork-chat-v2026.06.14-1-mac-arm64.tar.gz)**

### macOS（Intel 芯片）

**[⬇ 下载 mac-x64 版本](https://gitee.com/octowork/octowork-chat/releases/download/v2026.06.14-1/octowork-chat-v2026.06.14-1-mac-x64.tar.gz)**

### Windows 64位

**[⬇ 下载 win-x64 版本](https://gitee.com/octowork/octowork-chat/releases/download/v2026.06.14-1/octowork-chat-v2026.06.14-1-win-x64.zip)**

---

## 安装步骤

### macOS

1. 解压下载的 `.tar.gz` 文件
2. 双击 `首次安装.command`（首次使用）
3. 安装完成后浏览器自动打开，按网页向导填写 API Key
4. 日常使用双击 `启动服务.command`

> **首次运行提示：** macOS 可能提示"无法验证开发者"，请前往「系统设置 → 隐私与安全性」点击「仍要打开」。

### Windows

1. 解压下载的 `.zip` 文件
2. 双击 `首次安装.bat`（首次使用）
3. 安装完成后浏览器自动打开，按网页向导填写 API Key
4. 日常使用双击 `启动服务.bat`

---

## 系统要求

| 平台 | 要求 |
|------|------|
| macOS | macOS 12 Monterey 及以上 |
| Windows | Windows 10 64位 及以上 |
| 内存 | 建议 8GB 以上 |
| 磁盘 | 安装包约 300MB，运行时额外占用约 500MB |

---

## 更新日志

### v2026.06.14-1
- 🔒 程序核心模块加密混淆保护上线（P0/P1 全部完成）
- 🛡️ 三道打包安全门禁：策略分类 / 泄漏扫描 / 关键语法校验
- 🔄 升级脚本支持联网自动检测新版本并一键升级，SHA-256 完整性校验
- 🐛 修复 Windows 升级后用户配置（config.json）被覆盖问题

### v2026.06.14-1
- 首次安装后自动启动服务并打开浏览器
- 新增网页向导：无需手动编辑配置文件，在浏览器里填写 API Key 即可
- 修复启动脚本端口混用问题（BUG-2）
- 修复发动机未启动问题（BUG-3），AI 功能恢复正常

---

## 常见问题

**Q：安装后打开浏览器显示"无法连接"？**  
A：服务启动需要约 30 秒，请稍等后刷新页面。如仍无法连接，双击 `启动服务.command` 手动启动。

**Q：API Key 填错了怎么办？**  
A：进入主界面后，点击左侧导航「设置 → 密钥配置」随时修改。

**Q：如何升级到新版本？**  
A：程序会定时自动检测更新（每天一次）。有新版本时界面会出现升级提示，也可双击 `升级.command`（macOS）或 `升级.bat`（Windows）手动触发，支持 SHA-256 完整性校验与自动回滚。

---

## 联系我们

- 官网：https://octowork.ai
- 问题反馈：请通过官网联系我们
