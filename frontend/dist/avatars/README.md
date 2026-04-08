# OctoWork Avatar Library

## 📁 目录结构

```
avatars/
├── originals/    # 源文件 (1024x1024, 约1MB/个)
├── 64x64/        # 列表显示 (约8-12KB/个)
├── 256x256/      # 鼠标悬停 (约72-108KB/个)
├── 512x512/      # 详情查看 (约252-364KB/个)
└── departments/  # 部门默认头像
```

## 📊 统计信息

- **总头像数**: 56个
- **原图总大小**: 61MB
- **64x64总大小**: 556KB
- **256x256总大小**: 5.0MB
- **512x512总大小**: 18MB

## 🎨 使用方法

### 1. 在React组件中使用

```javascript
import { getAvatarUrl, getAllAvatarSizes, AVATAR_SIZES } from '../utils/avatarHelper';

// 获取小图（列表显示）
const smallAvatar = getAvatarUrl('octotech-chief', AVATAR_SIZES.SMALL);

// 获取中图（悬停显示）
const mediumAvatar = getAvatarUrl('octotech-chief', AVATAR_SIZES.MEDIUM);

// 获取大图（详情查看）
const largeAvatar = getAvatarUrl('octotech-chief', AVATAR_SIZES.LARGE);

// 获取所有尺寸
const avatars = getAllAvatarSizes('octotech-chief');
// 返回: { small, medium, large, original }
```

### 2. Bot列表实现示例

```jsx
function BotListItem({ bot }) {
  const [isHovered, setIsHovered] = useState(false);
  const avatarUrl = getAvatarUrl(
    bot.bot_id, 
    isHovered ? AVATAR_SIZES.MEDIUM : AVATAR_SIZES.SMALL
  );
  
  return (
    <div 
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <img src={avatarUrl} alt={bot.name_cn} />
    </div>
  );
}
```

### 3. 预加载头像

```javascript
import { preloadAvatar, preloadAvatars } from '../utils/avatarHelper';

// 预加载单个头像
await preloadAvatar('/avatars/256x256/octotech-chief.png');

// 预加载多个头像
const urls = bots.map(bot => getAvatarUrl(bot.bot_id, AVATAR_SIZES.MEDIUM));
await preloadAvatars(urls);
```

## 🎯 设计指南

### 颜色主题

| 部门 | 颜色 | 示例Bot |
|------|------|---------|
| OctoRed | 红色 | octored-manager.png |
| OctoTech-Team | 蓝色 | octotech-chief.png |
| OctoGuard | 绿色 | octoguard-data.png |
| OctoBrand | 紫色 | octobrand-manager.png |
| OctoAcademy | 橙色 | octoacademy-director.png |
| OctoVideo | 黄色 | octovideo-manager.png |
| The-Arsenal | 深灰 | arsenal-mining.png |
| The-Brain | 粉色 | brain-chief.png |
| The-Forge | 青色 | forge-manager.png |

### 生成提示词模板

```
基础模板：
Cute cartoon octopus avatar, [COLOR] color theme, [ACCESSORY/TOOL], 
[ROLE] style, round circular icon, no text, light solid background, 
flat design, kawaii style, [EXPRESSION], 8 tentacles visible

示例：
Cute cartoon octopus avatar, blue color theme, with VR goggles and lab coat, 
tech specialist style, round circular icon, no text, light solid background, 
flat design, kawaii style, focused expression, 8 tentacles visible
```

## 🔧 维护

### 添加新头像

1. 将原图（推荐1024x1024）放入 `originals/` 目录
2. 运行生成脚本：
```bash
cd tools && ./generate_avatar_sizes.sh
```

### 更新Bot映射

编辑 `frontend/src/utils/avatarHelper.js` 中的 `mapBotIdToFilename` 函数。

## 📝 更新日志

### 2026-03-18
- ✅ 初始化头像库（56个头像）
- ✅ 创建多尺寸支持 (64/256/512px)
- ✅ 添加Bot ID映射
- ✅ 创建Avatar Helper工具类

---
**OctoWork Team** - 让每个Bot都有独特的个性 🐙
