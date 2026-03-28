# Agents_Skills

这是一个用于存放 Agents Skill 的仓库。

仓库里的每个子目录都是一个独立 Skill，按统一结构组织：

```text
my-skill/
├── SKILL.md
├── references/
├── scripts/
└── assets/
```

目前已包含：

- `Grok4search`：只负责调用 Grok 接口执行搜索的 Skill，推荐使用 `assets/.env` 配置

## 仓库用途

这个仓库用于集中管理可复用的 Agent Skills，方便：

- 统一维护 Skill 目录结构
- 单独分发某个 Skill
- 作为个人或团队的 Skill 集合仓库

## 获取方式

如果你只想取单个 Skill，可以直接用 `npx degit` 拉取对应子目录。

例如拉取 `Grok4search`：

```bash
npx degit Likhixang/Agents_Skills/Grok4search
```

如果你要整个仓库：

```bash
git clone https://github.com/Likhixang/Agents_Skills.git
```

## Skill 说明

每个 Skill 的具体安装方法、配置方式和使用说明，见各自目录下的 `README.md`。
