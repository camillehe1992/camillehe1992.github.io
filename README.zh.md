# 个人技术博客

[中文](README.zh.md) ｜ [English](README.md)

使用 Hugo 和 Blowfish 主题构建、通过 GitHub Pages 发布的专业个人技术博客。

线上站点为 GitHub Pages 默认用户站点：<https://camillehe1992.github.io/>。

博客旨在记录实践工程工作，并作为长期作品集，覆盖：

- 公有云架构（AWS）
- 基础设施即代码（Terraform、CloudFormation）
- DevOps、CI/CD 和 GitHub Actions
- 云安全
- AI Engineering 和 RAG Applications

## 前置工具

仓库使用 Hugo Extended `0.165.0`（记录在 `.hugo-version`），与当前 Blowfish
v3 集成兼容。

本地工具：

- Git
- Hugo Extended `0.165.0`（见 `.hugo-version`）
- Go 1.21 或更高（Hugo Modules 需要）
- Node.js 22 或更高（Markdown 和 generated-site 检查需要）

## 本地工作流

文章创建与发布流程见[内容指南](docs/CONTENT_GUIDE.md)，涵盖文章结构、
front matter、图片、技术格式、编辑审阅和发布约定。

开发服务器包含 draft 内容，供本地预览（`hugo server --buildDrafts`）。
生产构建默认排除 draft，并将生成的输出写入不提交到源代码分支的 `public/`。

## 配置说明

- `config/_default/hugo.yaml`、`params.yaml`、`languages.en.yaml` 和 `menus.en.yaml` 保存站点和 Blowfish 配置。
- `baseURL` 配置为 GitHub Pages 用户站点地址 `https://camillehe1992.github.io/`。
- 技术文章位于 `content/posts/{aws,terraform,cloudformation,devops,security,ai}/`；front matter、图片、格式和编辑审阅约定见 [docs/CONTENT_GUIDE.md](docs/CONTENT_GUIDE.md)。
- Blowfish `v3.4.0` 通过 `config/_default/module.toml` 引入，并在 `go.mod`/`go.sum` 中固定。
- 真实 profile 链接在可公开的 URL 确定前保持未配置。Analytics、评论、Newsletter、Resume/CV 和 AI 辅助发布尚未实现，属于可选未来工作。

CI 在 Pull Request 中运行 Markdown、YAML、GitHub Actions syntax、Hugo 和
generated-site link 检查。本地安装 Node.js 22、`yamllint` 和 `actionlint`
可获得完全一致的检查结果。正式 pre-commit hooks、拼写检查、secret scanning、
定期检查和 Lighthouse 审计目前尚未实现。

## 仓库约定

- 源码内容和配置通过 Git 审阅和版本管理。
- 生成的 Hugo 输出不提交到源代码分支。
- 内容和配置变更使用 Pull Request。
- GitHub Actions 构建并部署已验证的 Pages artifact。
- 不得提交 secrets、凭据、私钥或敏感基础设施标识。

## 文档地图

- [内容指南](docs/CONTENT_GUIDE.md) ｜ [中文](docs/CONTENT_GUIDE.zh.md)：文章创建、编辑和发布约定。
- [网站维护规范](docs/WEBSITE_MAINTENANCE_GUIDE.md) ｜ [中文](docs/WEBSITE_MAINTENANCE_GUIDE.zh.md)：配置、部署、质量检查、未完成事项和未来规划。

## 许可与内容所有权

在把站点视为完整文档化的公开作品集之前，先添加项目许可和内容复用政策。
技术文章必须标明第三方材料并保留适用的许可。
