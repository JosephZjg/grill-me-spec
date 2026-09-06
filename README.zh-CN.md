# <img src="assets/icon.svg" width="96" valign="middle" alt="grill-me-spec 图标"/> grill-me-spec

[English](./README.md) | [简体中文](./README.zh-CN.md)

> 拷问方案，落成规范。

一个把**无情访谈**与 **[OpenSpec](https://github.com/Fission-AI/OpenSpec)** 规范驱动工作流配对的 agent skill：一次一个问题地压力测试一个变更想法，然后把确认后的共识固化为一份通过校验的 OpenSpec 变更提案。

## 为什么需要它

它解决两个常见的失败模式：

- 从一句话提示直接生成的 AI 提案，本质上是对你需求的"自信猜测"。
- 真正打磨过方案的对话，会话一结束就蒸发在聊天记录里。

grill-me-spec 把这两头接起来——**访谈本身就是提案的输入来源**：

- 每个被拷问出的决策 → `design.md`，**连同被否掉的备选方案**
- 每个被逼问出的边缘场景（"断网时打印到一半怎么办？"）→ 规范增量里的 `Scenario:`
- 范围边界与非目标 → `proposal.md`

从对话到规范，讨论过的东西一个不丢。

## 它在工作流里的位置

```
模糊想法 ──▶ explore ──▶ 方向确定 ──▶ grill-me-spec ──▶ apply ──▶ archive
             （发散）                （拷问 + 落盘）
```

| | OpenSpec explore 模式 | grill-me-spec |
|---|---|---|
| 姿态 | 发散——多线并行，跟着感觉走 | 收敛——沿设计树逐分支走 |
| 节奏 | 自由漫谈 | 一次一个问题，每个附推荐答案 |
| 结尾 | 可选（"要不要生成提案？"） | 必然——确认共识 → 通过校验的变更 |
| 变更中途返工 | 支持 | 不做——会把你引回 explore |

grill-me-spec 不替代 `explore`、`apply`、`archive`，它替代的是 `propose` 的**输入**：一句话提示变成被拷打过的共识。

## 环境要求

- 一个会从 skills 目录加载 skill 的 agent（Claude Code、Codex、ZCode 等）。
- 完整流程需要：[OpenSpec CLI](https://www.npmjs.com/package/@fission-ai/openspec)（`npm i -g @fission-ai/openspec`，Node 18+），且项目已用 `openspec init` 初始化。

**不需要安装其他 skill。** 访谈规则已内嵌——无需 grill-me/grilling，也无需 OpenSpec 的 agent skills。没有 OpenSpec CLI 时，skill 会优雅降级为纯访谈模式，结束时给你一份可粘贴到 issue 或文档的共识总结。

## 安装

一行命令安装 —— 自动探测 claude/codex/zcode（要显式指定可追加 `-s -- --tool <名称>` 或 `-s -- --dest <路径>`）：

```bash
curl -fsSL https://raw.githubusercontent.com/JosephZjg/grill-me-spec/main/install.sh | bash
```

```powershell
irm https://raw.githubusercontent.com/JosephZjg/grill-me-spec/main/install.ps1 | iex
```

兼容 macOS（系统自带 bash 3.2+）、Linux、Git Bash 和 Windows PowerShell 5.1+。

或者直接 clone 到你的 agent skills 目录：

```bash
git clone https://github.com/JosephZjg/grill-me-spec ~/.claude/skills/grill-me-spec   # Claude Code
git clone https://github.com/JosephZjg/grill-me-spec ~/.codex/skills/grill-me-spec   # Codex
git clone https://github.com/JosephZjg/grill-me-spec ~/.zcode/skills/grill-me-spec   # ZCode
```

> 国内网络建议改用 [Gitee 镜像](https://gitee.com/gather_limon/grill-me-spec)：把上面的 GitHub 地址换成 `https://gitee.com/gather_limon/grill-me-spec` 即可。

本地 clone 后也可以直接跑 `./install.sh` / `.\install.ps1`（探测逻辑与参数相同）。

## 用法

```
/grill-me-spec 给离线收银加挂单和取单功能
```

agent 会：

1. **检查与路由** —— 确认 OpenSpec CLI 和项目状态；想法还发散时，先引导去 explore 模式。
2. **拷问** —— 一次一个问题，每个附推荐答案。事实自己去代码里查，决策摆到你面前。
3. **共识总结待确认** —— 做什么、决策清单、边缘场景、范围外。你确认前一切不推进。
4. **落盘** —— `openspec new change` → `status` → `instructions` → 按项目 `context` 和 `rules` 写每个 artifact → `validate --strict`。
5. **停下。** 只有你明确发话才开始实施。

完整示例（访谈片段 → 产出 artifact）：[examples/offline-cashier.md](examples/offline-cashier.md)。

## 常见问题

**需要先装 grill-me / grilling 吗？**
不需要。访谈规则已内嵌在本 skill 里。（致谢：访谈姿态的灵感来自 Matt Pocock 的 grilling 系列 skills。）

**需要 OpenSpec 吗？**
落盘需要——artifact 通过 OpenSpec CLI 创建，校验也由它强制执行。没有它，skill 以纯访谈模式运行，结束时交付一份共识总结。

**它替代 `openspec-propose` 吗？**
替代的是它的输入。落盘用的是和 propose 相同的 CLI 机制，但 artifact 内容转录自一场确认过的访谈，而不是从一句话提示脑补出来的。

**ADR 放哪？**
按设计应当很少。只有同时满足"难以逆转、缺少上下文会令人困惑、存在真实权衡"三个条件的决策才值得一份持久 ADR，其余都留在变更自己的 `design.md` 里，随变更归档。

## 许可证

[MIT](./LICENSE)
