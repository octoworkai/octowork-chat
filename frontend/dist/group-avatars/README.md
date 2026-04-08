# OctoWork 群聊头像资源包

## 📦 资源概览

本目录包含 **10 个** 精心设计的群聊头像，每个头像都有 **4 种尺寸**：

- **64x64** - 列表缩略图
- **128x128** - 中等尺寸
- **256x256** - 高清显示（推荐）
- **1024x1024** - 原始尺寸（备用）

**总文件数**：40 个图片文件 + 配置文件
**总大小**：约 11 MB（包含所有尺寸）

---

## 🎨 头像列表

| ID | 文件名 | 描述 | 成员数 | 风格 |
|----|--------|------|--------|------|
| group-01 | group-01-circle.png | 三只章鱼围圈 - 团结协作 | 3 | 圆形 |
| group-02 | group-02-pyramid.png | 四只章鱼金字塔 - 层次分明 | 4 | 金字塔 |
| group-03 | group-03-rainbow.png | 五只章鱼手拉手 - 多元包容 | 5 | 彩虹 |
| group-04 | group-04-hug.png | 三只章鱼拥抱 - 亲密关系 | 3 | 拥抱 |
| group-05 | group-05-meeting.png | 四只章鱼开会 - 高效沟通 | 4 | 会议 |
| group-06 | group-06-hexagon.png | 六只章鱼六边形 - 完整网络 | 6 | 六边形 |
| group-07 | group-07-highfive.png | 三只章鱼击掌 - 成功庆祝 | 3 | 击掌 |
| group-08 | group-08-square.png | 四只章鱼方阵 - 稳定结构 | 4 | 方阵 |
| group-09 | group-09-star.png | 五只章鱼星形 - 创新活力 | 5 | 星形 |
| group-10 | group-10-friends.png | 三只章鱼好友 - 友谊信任 | 3 | 好友 |

---

## 🚀 使用方法

### 方法1：使用工具函数（推荐）

```javascript
import { getGroupAvatar, getRandomGroupAvatar } from '@/utils/groupAvatarHelper'

// 为特定群聊获取稳定的头像（同一个群聊ID总是返回同一个头像）
const avatar1 = getGroupAvatar('group_123', '256x256')
// 返回: /group-avatars/256x256/group-05-meeting.png

// 随机选择一个头像
const avatar2 = getRandomGroupAvatar('128x128')
// 返回: /group-avatars/128x128/group-03-rainbow.png
```

### 方法2：直接访问路径

```javascript
// 基础路径
const avatarPath = '/group-avatars/256x256/group-01-circle.png'

// 在 Vue 组件中
<template>
  <img :src="avatarPath" alt="Group Avatar" />
</template>
```

### 方法3：使用 JSON 配置

```javascript
import groupAvatarsConfig from '@/public/group-avatars/group-avatars.json'

// 获取所有头像信息
const avatars = groupAvatarsConfig.avatars
console.log(avatars[0].name) // "Circle Team"
```

---

## 📝 工具函数 API

### `getGroupAvatar(groupId, size)`
为特定群聊获取稳定的头像（基于 groupId 哈希）

**参数**：
- `groupId` (string): 群聊ID
- `size` (string): 尺寸 - '64x64' | '128x128' | '256x256' | 'original'

**返回**：(string) 头像路径

**示例**：
```javascript
const avatar = getGroupAvatar('chat_room_456', '256x256')
```

---

### `getRandomGroupAvatar(size)`
随机选择一个群聊头像

**参数**：
- `size` (string): 尺寸

**返回**：(string) 头像路径

**示例**：
```javascript
const randomAvatar = getRandomGroupAvatar('128x128')
```

---

### `setGroupAvatar(groupId, avatarFilename)`
为群聊设置特定头像

**参数**：
- `groupId` (string): 群聊ID
- `avatarFilename` (string): 头像文件名（如 'group-01-circle.png'）

**示例**：
```javascript
setGroupAvatar('chat_room_789', 'group-03-rainbow.png')
```

---

### `getAllGroupAvatars(size)`
获取所有可用的群聊头像路径

**参数**：
- `size` (string): 尺寸

**返回**：(Array<string>) 头像路径数组

**示例**：
```javascript
const allAvatars = getAllGroupAvatars('256x256')
// 返回 10 个头像路径的数组
```

---

### `clearGroupAvatarCache(groupId)`
清除群聊头像缓存

**参数**：
- `groupId` (string|null): 群聊ID（可选，不传则清除所有）

**示例**：
```javascript
// 清除特定群聊的头像缓存
clearGroupAvatarCache('chat_room_123')

// 清除所有群聊头像缓存
clearGroupAvatarCache()
```

---

### `getGroupAvatarInfo(avatarFilename)`
获取头像的详细信息

**参数**：
- `avatarFilename` (string): 头像文件名

**返回**：(object) 包含 name、description、memberCount 的对象

**示例**：
```javascript
const info = getGroupAvatarInfo('group-01-circle.png')
console.log(info)
// { name: 'Circle Team', description: '三只章鱼围圈 - 象征团结协作', memberCount: 3 }
```

---

## 🎯 实战示例

### 在群聊列表中使用

```vue
<template>
  <div class="group-list">
    <div v-for="group in groups" :key="group.id" class="group-item">
      <img 
        :src="getGroupAvatar(group.id, '64x64')" 
        :alt="group.name"
        class="group-avatar"
      />
      <span>{{ group.name }}</span>
    </div>
  </div>
</template>

<script setup>
import { getGroupAvatar } from '@/utils/groupAvatarHelper'

const groups = [
  { id: 'room_001', name: '开发团队' },
  { id: 'room_002', name: '产品讨论' },
  { id: 'room_003', name: '设计交流' }
]
</script>
```

### 创建新群聊时随机分配头像

```javascript
import { getRandomGroupAvatar } from '@/utils/groupAvatarHelper'

function createNewGroup(groupName) {
  const groupData = {
    id: generateGroupId(),
    name: groupName,
    avatar: getRandomGroupAvatar('256x256'),
    createdAt: Date.now()
  }
  
  // 保存群聊数据...
  return groupData
}
```

### 允许用户选择群聊头像

```vue
<template>
  <div class="avatar-selector">
    <h3>选择群聊头像</h3>
    <div class="avatar-grid">
      <img
        v-for="(avatar, index) in allAvatars"
        :key="index"
        :src="avatar"
        @click="selectAvatar(index)"
        :class="{ selected: selectedIndex === index }"
      />
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { getAllGroupAvatars, setGroupAvatar } from '@/utils/groupAvatarHelper'

const allAvatars = getAllGroupAvatars('128x128')
const selectedIndex = ref(0)

function selectAvatar(index) {
  selectedIndex.value = index
  const filename = allAvatars[index].split('/').pop()
  setGroupAvatar('current_group_id', filename)
}
</script>
```

---

## 🔧 技术细节

### 头像生成提示词

所有头像使用 **nano-banana-pro** 模型生成，提示词模板：

```
A cute group chat icon featuring [N] small cartoon octopuses [arrangement].
Colors: [color list with hex codes].
Each wearing tiny black-rimmed glasses and showing friendly smiles.
[Special features description].
Simple flat design, white background, perfect for app icon, 1024x1024px.
```

### 文件结构

```
group-avatars/
├── 64x64/               # 小尺寸（列表缩略图）
│   ├── group-01-circle.png
│   ├── ...
│   └── group-10-friends.png
├── 128x128/             # 中等尺寸
│   ├── group-01-circle.png
│   ├── ...
│   └── group-10-friends.png
├── 256x256/             # 高清尺寸（推荐）
│   ├── group-01-circle.png
│   ├── ...
│   └── group-10-friends.png
├── group-01-circle.png  # 原始尺寸 1024x1024
├── group-02-pyramid.png
├── ...
├── group-10-friends.png
├── group-avatars.json   # 配置文件
└── README.md            # 本文档
```

---

## 🎨 设计原则

1. **统一风格**：所有头像保持 OctoWork 品牌的章鱼元素和扁平化设计
2. **色彩丰富**：使用鲜明的颜色组合，便于区分不同群聊
3. **象征意义**：每个头像的设计都有特定的团队协作含义
4. **可爱友好**：保持可爱风格，降低用户使用门槛
5. **多尺寸支持**：提供4种尺寸适应不同使用场景

---

## 📊 使用建议

| 场景 | 推荐尺寸 | 说明 |
|------|----------|------|
| 群聊列表项 | 64x64 | 节省带宽，加载快 |
| 群聊详情页 | 256x256 | 高清显示，细节清晰 |
| 群聊设置页 | 128x128 | 平衡清晰度和加载速度 |
| 选择器预览 | 128x128 | 适中尺寸，方便选择 |
| 打印/导出 | original | 保证最高质量 |

---

## 🔄 更新日志

### v1.0.0 (2026-03-18)
- ✅ 初始版本
- ✅ 10 个群聊头像设计
- ✅ 4 种尺寸支持
- ✅ 工具函数库
- ✅ JSON 配置文件
- ✅ 完整文档

---

## 📝 License

本资源包为 OctoWork 项目专用，所有头像版权归项目所有。

生成时间：2026-03-18
生成工具：GenSpark AI (nano-banana-pro model)
