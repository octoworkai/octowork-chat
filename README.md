# OctoWork Chat Manager

> 章鱼工作室 · AI 智能体工作台  
> 最新版本：V2026.06.04

---

## 下载安装

### macOS（Apple Silicon / M系列芯片）

**[⬇ 下载 mac-arm64 版本](https://gitee.com/octowork/octowork-chat/releases/download/V2026.06.04/octowork-chat-V2026.06.04-mac-arm64.tar.gz)**

### macOS（Intel 芯片）

**[⬇ 下载 mac-x64 版本](https://gitee.com/octowork/octowork-chat/releases/download/V2026.06.04/octowork-chat-V2026.06.04-mac-x64.tar.gz)**

### Windows 64位

**[⬇ 下载 win-x64 版本](https://gitee.com/octowork/octowork-chat/releases/download/V2026.06.04/octowork-chat-V2026.06.04-win-x64.zip)**

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

### V2026.06.04
- 三平台完整打包：mac-arm64 / mac-x64 / win-x64
- 修复 backend/db 过滤逻辑：代码文件进包，运行数据排除
- Windows 原生模块（sqlite3）在目标机编译，不再跨平台复制
- 启动脚本重构优化，健康检查更稳定

### V2026.06.03-01
- 首次安装自动启动服务并打开浏览器
- 网页向导填写 API Key，无需手动编辑 .env 配置文件
- 修复启动脚本：先起 engine(2888) → 再起 backend(1314) → 打开 1314 网页
- 修复 engine bytenode 加密导致 .jsc 空壳、生图功能不可用（Mac 包）
- 修复 backend/db 整目录误删导致 database.js 丢失（Windows 包）
- 修复 Windows bat 脚本 UTF-8 BOM 编码乱码
- 修复 Windows 首次安装 .env.template 文件名不匹配
- 修复默认端口 1314 Windows 权限拒绝 → 默认改为 2888
- 已知：mac-x64 / win-x64 平台暂未产出，下载链接待补充

---

## 常见问题

**Q：安装后打开浏览器显示"无法连接"？**  
A：服务启动需要约 30 秒，请稍等后刷新页面。如仍无法连接，双击 `启动服务.command` 手动启动。

**Q：API Key 填错了怎么办？**  
A：进入主界面后，点击左侧导航「设置 → 密钥配置」随时修改。

**Q：如何升级到新版本？**  
A：程序会自动检测更新，有新版本时右上角会出现提示，点击即可一键升级。

---

## 联系我们

- 官网：https://octowork.ai
- 问题反馈：请通过官网联系我们
