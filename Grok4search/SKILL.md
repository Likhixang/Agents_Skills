# Grok4search

一个只用于调用 Grok 接口执行搜索的 Skill，不承担代码生成、数据分析或其他扩展任务。

## 适用场景

当用户提出以下类型的请求时使用本 Skill：

- 搜索某个主题的最新资料、新闻或网页信息
- 基于 Grok 搜索结果整理简短答案
- 需要通过自定义 Grok 兼容接口完成检索

## 配置方式

本 Skill 按以下顺序读取配置：

1. `assets/.env`
2. `assets/config.json`

推荐使用 `assets/.env`，不需要 `export`。

支持的配置项：

- `GROK_BASE_URL`
- `GROK_API_KEY`
- `GROK_MODEL`，可选，默认 `grok-4`

## 工作流程

1. 先检查 `assets/.env` 和 `assets/config.json`。
2. 如果 `base_url` 或 `api_key` 缺失，必须先提示用户补充配置，不得继续调用脚本。
3. 再读取 `references/usage.md`，按其中约定组织搜索请求。
4. 执行 `scripts/grok_search.sh "<query>"`。
5. 根据返回结果整理简短回答，并尽量保留来源、时间和不确定性说明。

## 执行规则

- 这个 Skill 只做 Grok 搜索，不做别的。
- 若配置缺失，先提示用户补充 `assets/.env` 或 `assets/config.json`。
- 若接口返回失败，先原样说明错误，再提示用户检查地址、密钥和模型名。
- 若用户没有指定语言，默认使用用户提问的语言输出。
- 若结果涉及时效性强的内容，明确说明答案依赖当前接口返回结果。

## 缺失配置时的提示语

当配置缺失时，直接提示：

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

## 脚本

- `scripts/grok_search.sh`：向 Grok 兼容接口发起搜索请求

## 快速开始

1. 复制 `assets/.env.example` 为 `assets/.env`
2. 填写 `GROK_BASE_URL` 和 `GROK_API_KEY`
3. 运行：

```bash
bash scripts/grok_search.sh "OpenAI 最新模型发布"
```
