# OctoWork 聊天管理器 vV2026.04.13.1

## 安装步骤

1. 解压到 `~/octowork-chat/`
2. 安装依赖: `cd backend && npm install --production`
3. 启动: `./start.sh`
4. 打开浏览器: http://127.0.0.1:1314

## 首次激活

首次启动会显示机器指纹，将指纹发送给管理员获取 license.key，
放到 `~/octowork-chat/license.key` 后重启即可。

## 目录要求

- `~/.openclaw/` — AI 执行引擎（需预装）
- `~/octowork/` — 数字公寓（需预装）
- `~/octowork-chat/` — 本程序
