<p align="center">
  <img src="docs/assets/icon.png" width="128" alt="Paracosm 图标" />
</p>

<h1 align="center">Paracosm</h1>
<p align="center"><strong>纯客户端 AI 角色扮演 App</strong></p>

和 AI 角色聊天、玩视觉小说剧情。用户自带 API key，本地 SQLite 存储 —— **无服务器、无账号、无云同步**，你的角色、剧情与记忆只属于你。

## 下载

> 📦 最新 APK 见 [Releases](https://github.com/99cz99/paracosm/releases)（Android 安装需允许「安装未知来源应用」）

## 功能特性

- 💬 **单聊流式** —— SSE 流式回复，后台继续生成；开场白自动发出、可切换
- 👥 **群聊 · 三模式** —— 多角色同屏，角色对关系驱动互动
- 📖 **剧情 · 分支树** —— AI 生成剧情，可跳转 / 回退 / 存档
- 🌍 **世界书** —— 关键词注入世界规则，角色内置 + 共享库多对多绑定
- 🧠 **记忆系统** —— 结构化状态 + 滚动摘要，按「角色 × 世界」隔离
- 🔒 **隐私本地** —— 无账号无云同步，API key 加密存本机，数据可全量备份

## 使用说明

1. **准备 API key** —— 前往模型服务商（DeepSeek / Kimi / GLM / SiliconFlow / OpenAI / Anthropic 等）获取 API key
2. **安装并配置** —— 安装 APK 后进入「我 → API Provider」填入 key 并「测试连接」
3. **导入角色** —— 在「联系人」导入酒馆卡（PNG / JSON）或 Skill（ZIP / MD），也可手动创建
4. **开始玩耍** —— 单聊、群聊、剧情、异世界随意切换，记忆与世界书自动注入

## 隐私说明

- 无服务器、无账号、无云同步
- 角色 / 剧情 / 记忆仅存本地 SQLite
- API key 仅本机加密存储，不随备份导出，只用于请求你配置的服务商
- 备份文件含对话数据，请自行保管、勿公开分享

## FAQ

- **支持哪些模型？** 兼容 OpenAI 接口（DeepSeek / Kimi / GLM / SiliconFlow / OpenAI）与 Anthropic Messages API，可在「我 → API Provider」点选切换。
- **数据存在哪？** 全部存本机 SQLite，卸载前请记得备份。
- **收费吗？** App 免费；聊天消耗你自备 API key 的额度，按各服务商计费。

