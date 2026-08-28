# 内容创作指南

[中文](CONTENT_GUIDE.zh.md) ｜ [English](CONTENT_GUIDE.md)

本指南定义当前技术文章和作品集内容的创作、审核与发布流程。内容位于
`content/`，以 Markdown 形式审阅；生成的 `public/` 输出不提交。站点级部署
与维护规则见 [WEBSITE_MAINTENANCE_GUIDE.md](WEBSITE_MAINTENANCE_GUIDE.md) ｜
[中文](WEBSITE_MAINTENANCE_GUIDE.zh.md)。

## 内容结构

文章按主题分组：

```text
content/posts/
├── aws/
├── terraform/
├── cloudformation/
├── devops/
├── security/
└── ai/
```

`rag` 目前属于 `ai` 主题下的分类，不单独建立目录，在保持导航紧凑的同时仍可
通过 `categories: [AI, RAG]` 发现 RAG 内容。每个主题目录保留 `_index.md`
作为稳定的列表页。文件名使用小写 kebab-case。

## Front matter

`archetypes/posts.md` 提供与 Blowfish 兼容的 YAML front matter：

```yaml
title: "清晰、具体的技术标题"
date: 2026-08-27T09:00:00+08:00
draft: true
description: "用于搜索和社交分享的简短描述。"
summary: "文章列表和卡片摘要。"
categories: [AWS]
tags: [IAM, Security]
author: "Camille He"
featuredImage: ""
featuredImageAlt: ""
series: []
```

`featuredImage` 和 `featuredImageAlt` 应配套使用。`series` 可选。
description 是元数据，summary 是面向读者的预览。审阅完成后才设置
`draft: false`。

已配置的分类为 AWS、Terraform、CloudFormation、DevOps、Security、AI 和
RAG；tags 用于 EC2、VPC、IAM、Kubernetes、GitHub Actions、CI/CD、LLM、
Vector Database 等具体技术。Hugo 标准 taxonomy 在
`config/_default/hugo.yaml` 中启用，并由 Blowfish 渲染。

## 文章结构

以 archetype 标题为灵活起点：Overview、Background、Architecture / Design、
Implementation、Configuration Examples、Validation、Lessons Learned 和
References。删除对文章无用的章节。页面使用主题提供的 H1，正文从 H2 开始。

## 图片与可视化

文章专属图片优先使用 page bundle：

```text
content/posts/aws/example/
├── index.md
└── architecture.svg
```

这使图片与文章放在一起，并避免文件名冲突。`static/images/` 仅用于站点级
资源。需要 Hugo 处理的资源放在 `assets/`；直接发布的 favicon、下载文件和
稳定图片放在 `static/`。优先使用版本化 SVG 或优化后的 PNG；Mermaid 只有在
本地和生产渲染都验证通过后才引入。每张图片都需要 alt text，第三方图片需要
attribution。架构图应辅助而非替代文字说明，不得描绘不存在的系统、指标或
项目。

## 技术格式

代码块必须标注语言标识：Terraform 用 `hcl`、AWS CLI 用 `sh`、配置用
`yaml`、Python 用 `python`、JSON 用 `json`。占位符要显式标注，例如
`<your-aws-profile>` 或 `${YOUR_ACCOUNT_ID}`；绝不使用真实凭据或私有标识。

```hcl
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}
```

命令输出放在 `text` 代码块中。命令需要说明前置条件、关键参数和预期结果，
解释非显然参数，并展示预期验证结果。Hugo Goldmark 和 Blowfish 提供代码
高亮与复制功能。

## 本地发布流程

1. 创建草稿：`hugo new posts/<topic>/<slug>.md`。
2. 编辑 front matter 和章节；需要时添加 page-bundle 图片。
3. 使用 `hugo server -D` 预览草稿。
4. 检查链接、代码、拼写、无障碍、移动端布局和敏感值。
5. 运行 `hugo --minify --panicOnWarning` 并确认构建成功。
6. 在 Node.js 22、`yamllint` 和 `actionlint` 可用时运行仓库质量检查。
7. 设置 `draft: false`，再审阅一次，创建 Pull Request。
8. 合并审阅通过的变更到 `main` 完成发布；GitHub Actions 部署已验证的
   Pages artifact。
9. 合并后检查线上页面、资源、RSS、sitemap、canonical URL 和 404 页面。

本地常用命令：

```sh
hugo server --buildDrafts
hugo --minify
npm ci
npm run lint:markdown
yamllint -c .yamllint .github config
hugo --minify --panicOnWarning
npm run check:links

# 完整的 CI 等价质量检查（需要 yamllint 和 actionlint）
.github/scripts/validate-quality.sh

# 提交前的可选快速检查
pre-commit run --all-files
```

## 编辑检查清单

- [ ] Front matter 完整且日期是刻意设置的。
- [ ] 技术事实、命令、AWS 行为和版本信息准确。
- [ ] 没有凭据、私钥、账号 ID 或敏感值。
- [ ] 代码块有语言标识、安全占位符和验证步骤。
- [ ] 链接可访问，参考资料优先使用官方文档。
- [ ] 图片有 alt text、合理大小，必要时有 attribution。
- [ ] 标题层级有序、行文清晰、移动端表现正常。
- [ ] 草稿已预览，生产构建成功。

## 作品集内容规范

作品集页面使用以下可复用结构：

- **项目卡片：** 以问题和结果开头，再列出架构、技术、安全、成本、仓库和经验。
- **技术 tags：** 使用简短、稳定的名称，如 `AWS`、`Terraform`、`GitHub Actions`、`Security` 和 `RAG`；tags 只用于具体技术或主题。
- **架构展示：** 用真实、可分享的图配合简明的边界、自动化和权衡说明。不得虚构系统、指标或图。
- **精选文章：** 只链接已通过编辑检查清单并已发布的文章；主页可通过现有 Blowfish profile 布局展示近期文章。
- **GitHub 链接：** 手动为已发布的案例研究添加仓库 URL。站点有意不调用 GitHub API。

Resume/CV、Analytics、自定义域名、评论/Newsletter 和 AI 辅助发布在具备真实
内容和明确的维护责任前暂缓。当前站点仍可通过现有 GitHub Pages workflow
部署。

## 当前发布边界

公开站点目前没有已发布的 dated technical articles，也没有已确认的公开
仓库、profile 或 contact 链接。没有可发布的一手素材时，不得创建代表性
项目、指标、架构图或个人宣称。RAG 仍属于 `ai` 主题下的分类，不是独立内容
分区。Projects 页面中的 AWS、CI/CD 和 AI/RAG 条目是内容模板，不是已完成的
真实项目，不应描述为真实项目。
