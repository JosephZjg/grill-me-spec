# 工作流指南

一个变更如何从想法走到归档规范，grill-me-spec 负责其中的访谈环节。基于 OpenSpec CLI 1.9 编写（下文工作流名称均为其内置名称）。

## 一次性初始化（每个项目只做一次）

```bash
cd 你的项目
openspec init      # 创建 openspec/（specs/ + changes/ + config.yaml）
```

然后编辑 `openspec/config.yaml`：

- `context` — 项目背景：技术栈、约定、约束。
- `rules` — 各 artifact 的规则，agent 写提案时必须遵守。

接手陌生项目？`/openspec-onboard` 能帮 agent 快速建立认知。

## 日常变更主循环

每个功能或修复都走这个环：

```
 想法
  │
  ├─ 还发散（"要不要做 X？" / "Postgres 还是 SQLite？"）
  │    └→ /openspec-explore       开放式调研：读代码、比方案、画图，无强制产出
  │
  ├─ 已收敛（知道要做什么了）
  │    └→ /grill-me-spec <想法>   ★ 本 skill 插在这里
  │         ① 前置检查（CLI + 项目）
  │         ② 拷问：一次一个问题、每个附推荐答案；
  │            事实自己查代码和 specs，决策摆给你
  │         ③ 共识总结 → 你确认
  │         ④ CLI 落盘：proposal / design / spec deltas / tasks
  │         ⑤ validate --strict → 停下，等你发话
  │
  ├─ 小事不想访谈，一句话直接出提案
  │    └→ /openspec-propose <描述>（跳过拷问，质量自负）
  ▼
 changes/<变更名>/   ← 提案在这里，你可以直接改文件
  │
  ▼ 确认提案后
 /openspec-apply-change <变更名>     按 tasks.md 实施，完成一项勾一项
  │
  ▼ 实施完成
 /openspec-verify-change <变更名>    对照 spec 验收（可选，推荐）
  │
  ▼
 openspec archive <变更名>           delta 合并进 specs/，
 │                                   变更挪入 changes/archive/
 ▼
 回到"想法"——specs 基线已更新
```

## 中途的旁路

| 情况 | 用什么 |
|---|---|
| 实施到一半发现设计要改 | `/openspec-explore <变更名>` — 讨论后改 design.md |
| 昨天的变更做了一半，今天继续 | `/openspec-continue-change <变更名>` |
| 新信息导致提案本身要改 | `/openspec-update-change <变更名>` |
| 代码先动了，specs 落后了 | `/openspec-sync-specs` 把现状同步回 specs |
| 一堆旧变更想一次归档 | `/openspec-bulk-archive-change` |

## CLI 速查

```bash
openspec list                     # 进行中的变更
openspec list --specs             # 已确立的能力规范
openspec show <变更名>            # 查看某个变更
openspec spec show <能力id>       # 查看某个能力规范
openspec status --change <名>     # 变更 artifact 完成度
openspec validate <名> --strict   # 校验（落盘后必跑）
openspec view                     # 交互仪表盘
openspec doctor                   # 环境健康检查
```

## 三条纪律（保持这套系统不烂掉的关键）

1. **validate 不过不 apply，实施不完不 archive。** 归档是 specs 基线唯一的更新口（例外：纯工具/文档类变更可用 `archive --skip-specs`）。
2. **specs 永不手改。** 它只能通过"变更 delta → 归档时合并"演进，或代码先行漂移时走 sync-specs 对齐——这保证每条 Requirement 都能追溯到引入它的那次变更。
3. **拷问的共识别只留在聊天里。** 这正是 grill-me-spec 存在的理由：走完访谈就落成提案，靠文件，不靠记忆。

---

[English](./workflow.md) | [中文](./workflow.zh-CN.md)
