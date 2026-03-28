# Grok4search Usage

## 定位

这个 Skill 只负责一件事：调用 Grok 接口做搜索。

它不负责：

- 写代码
- 改代码
- 跑测试
- 做额外抓取

## 配置优先级

优先读取：

1. `assets/.env`
2. `assets/config.json`

推荐使用 `assets/.env`。

`.env` 示例：

```env
GROK_BASE_URL=https://your-grok-endpoint.example.com
GROK_API_KEY=your_api_key_here
GROK_MODEL=grok-4
```

`config.json` 示例：

```json
{
  "base_url": "https://your-grok-endpoint.example.com",
  "api_key": "your_api_key_here",
  "model": "grok-4",
  "search_mode": "auto"
}
```

## 请求约定

脚本会请求：

- `POST {base_url}/chat/completions`

请求体采用 OpenAI 兼容格式，系统提示会明确要求模型只做搜索和结果整理。

## 使用建议

- 查询词尽量具体。
- 涉及时效性内容时，优先要求返回来源和时间。
- 如果要比较多个对象，在同一个查询里说明比较维度。

## 出错处理

如果请求失败，优先检查：

- `base_url` 是否正确
- 接口路径是否为 `/chat/completions`
- `api_key` 是否有效
- `model` 是否为你的接口实际支持的模型名

如果 `base_url` 或 `api_key` 缺失，Skill 不应继续执行，而应先提示用户补配置。
