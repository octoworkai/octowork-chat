# OctoWork 部门头像库

这个目录包含了 OctoWork 9个部门的主题色章鱼头像。

## 🎨 部门色彩体系

| 部门名称 | 文件名 | 主题色 | 说明 |
|---------|--------|--------|------|
| OctoRed | `octored.png` | 🔴 红色 | 小红书管理部门 |
| OctoTech | `octotech.png` | 🔵 蓝色 | 技术开发部门 |
| OctoBrand | `octobrand.png` | 🟣 紫色 | 品牌营销部门 |
| OctoGuard | `octoguard.png` | 🟢 绿色 | 安全防护部门 |
| OctoAcademy | `octoacademy.png` | 🟠 橙色 | 学院教育部门 |
| OctoVideo | `octovideo.png` | 🟡 黄色 | 视频制作部门 |
| The-Arsenal | `the-arsenal.png` | ⚫ 深灰 | 武器库部门 |
| The-Brain | `the-brain.png` | 🩷 粉色 | 智库策略部门 |
| The-Forge | `the-forge.png` | 🟤 棕色 | 锻造工坊部门 |

## 📐 规格说明

- **尺寸**: 1024x1024 像素
- **格式**: PNG
- **背景**: 透明/浅色
- **风格**: 扁平化卡通风格
- **表情**: 友好微笑 + 大眼睛

## 🔧 使用方法

### 在前端代码中引用

```javascript
// 按部门获取头像
const avatarPath = `/avatars/departments/${departmentName.toLowerCase()}.png`

// 示例
const octoRedAvatar = '/avatars/departments/octored.png'
const octoTechAvatar = '/avatars/departments/octotech.png'
```

### 在 ai-directory.json 中配置

```json
{
  "bot_id": "example-bot",
  "department": "OctoTech",
  "avatar": "avatars/departments/octotech.png"
}
```

## 🎨 设计特点

1. **主题统一**: 所有头像都是章鱼（Octopus），呼应 OctoWork 品牌
2. **色彩区分**: 每个部门独特的颜色，便于快速识别
3. **风格一致**: 统一的卡通扁平化设计语言
4. **表情友好**: 所有章鱼都带有友好的微笑表情

## 📅 更新日志

- **2026-03-18**: 初始版本，创建9个部门主题色章鱼头像
