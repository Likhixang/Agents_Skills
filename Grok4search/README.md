# Grok4search

`Grok4search` 是一个只负责调用 Grok 做搜索的 Skill。

它不负责代码生成、代码修改、测试执行或额外抓取。

## 安装

如果你只想安装这个 Skill，可以直接用 `npx` 拉取：

```bash
npx degit Likhixang/Agents_Skills/Grok4search
```

如果你已经克隆了整个仓库，也可以直接使用当前目录。

把目录放到你的 Skills 目录后，按下面配置即可使用。

1. 复制 [assets/.env.example](/home/li_khixang/Agents_Skills/Grok4search/assets/.env.example) 为 `assets/.env`
2. 填写你的接口地址和密钥
3. 按需修改模型名，不改则默认 `grok-4`

推荐的 `assets/.env` 内容：

```env
GROK_BASE_URL=https://your-grok-endpoint.example.com
GROK_API_KEY=your_api_key_here
GROK_MODEL=grok-4
```

也可以使用 [assets/config.json](/home/li_khixang/Agents_Skills/Grok4search/assets/config.json)，但优先推荐 `.env`。

如果你使用 `npx degit` 拉取后，初始化步骤也是一样的：

1. 进入 `Grok4search`
2. 复制 `assets/.env.example` 为 `assets/.env`
3. 填写配置后开始使用

## 使用

命令行测试：

```bash
bash scripts/grok_search.sh "最近的 AI 新闻"
```

如果由 AI 调用这个 Skill，流程应当是：

1. 先检查 `assets/.env` 或 `assets/config.json`
2. 缺配置时先提示用户补齐
3. 有配置后再执行搜索
4. 返回简短结论、关键信息、来源和不确定项

## 报错说明

如果没有配置，会提示：

```text
Grok4search 还没有可用配置。请先填写以下任一文件：
1. assets/.env
2. assets/config.json

至少需要：
- GROK_BASE_URL
- GROK_API_KEY

可选：
- GROK_MODEL，默认 grok-4
```

如果接口调用失败，优先检查：

- 地址是否正确
- Key 是否有效
- 模型名是否可用
- 你的网关是否兼容 `/chat/completions`
