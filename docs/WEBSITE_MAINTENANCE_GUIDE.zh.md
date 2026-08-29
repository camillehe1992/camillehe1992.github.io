# 个人技术网站维护规范

[中文](WEBSITE_MAINTENANCE_GUIDE.zh.md) ｜ [English](WEBSITE_MAINTENANCE_GUIDE.md)

本文档是维护 `https://camillehe1992.github.io/`（GitHub Pages 默认用户站点）
的操作规范。文章创作与发布约定见 [CONTENT_GUIDE.md](CONTENT_GUIDE.md) ｜
[中文](CONTENT_GUIDE.zh.md)。

## 1. 当前站点边界

关于技术栈、Hugo Modules 集成、Pages URL 和部署模型的已确认事实见
[README.md](../README.md)（Prerequisites、Configuration notes、Repository
conventions），本指南不再重复。

## 2. 维护原则

- 保持 Hugo 和 Blowfish，不因局部需求替换主题或部署架构。
- 优先使用 Hugo 配置、内容 Markdown 和小范围模板覆盖，避免不必要的依赖。
- 不编辑 Blowfish 依赖目录；主题定制放在配置、`layouts/`、`assets/` 或明确的覆盖文件中。
- 不提交凭据、私钥、访问令牌、账号 ID、私有主机名、个人隐私或敏感基础设施信息。
- 不虚构项目、架构、性能指标、仓库链接、工作经历或个人联系方式。
- 每次变更都应能通过 Git review，并保持可回滚。
- 先验证，再部署；只允许经过生产构建的 `public/` 作为 Pages artifact。

## 3. 仓库与分支维护

### 日常规范

- 文章和配置修改使用短生命周期分支，并通过 Pull Request 合并。
- 保持提交聚焦，避免把无关格式化、生成文件或依赖升级混入内容变更。
- 不提交生成目录、临时文件或本地依赖。
- 主题、Hugo 和 CI 工具升级应单独提交并记录版本变化。
- 需要时为重要站点版本或主题升级创建 Git tag。

## 4. Hugo 与 Blowfish 维护

### 当前配置

- `baseURL` 必须保持为 `https://camillehe1992.github.io/`。
- 内容语言为 English，时区为 `Asia/Shanghai`。
- 主导航为 Home、Posts、Projects、About。
- 搜索、RSS、sitemap、robots、暗色模式、代码复制和无障碍选项已启用。

### 配置变更流程

1. 先阅读当前 `config/_default/hugo.yaml`、`params.yaml`、语言和菜单配置。
2. 只修改满足需求的配置项，并检查是否会改变 URL、taxonomy 或输出格式。
3. 运行 `hugo --minify --panicOnWarning`。
4. 检查主页、About、Projects、Posts、RSS、sitemap、robots 和 canonical URL。
5. 将配置变更与验证结果写入 PR 描述。

### 主题升级流程

1. 查看 Blowfish 当前版本和 Hugo 兼容性要求。
2. 更新 Hugo Module 版本及相关校验文件。
3. 检查主题变更对导航、首页布局、搜索、SEO、RSS 和暗色模式的影响。
4. 在本地完成生产构建和核心页面检查。
5. 通过 PR 验证后再合并和部署。

## 5. 内容发布规范

文章创建、front matter、技术格式、图片和发布流程见
[CONTENT_GUIDE.md](CONTENT_GUIDE.md) ｜ [中文](CONTENT_GUIDE.zh.md)，本指南
不再重复。

维护特有的内容约定：

- 已发布 URL 不要随意修改；必须修改时设计重定向方案。

## 6. GitHub Pages 部署维护

### 当前部署模型

```text
Developer → Pull Request checks → merge to main
         → Hugo production build → Pages artifact
         → github-pages Environment → public site
```

- Pages Source 使用 GitHub Actions。
- `github-pages` Environment 已配置。
- workflow 使用最小化的 `contents`、`pages` 和 `id-token` 权限范围。
- Pages artifact 只上传生成的 `public/`。
- workflow 使用 concurrency 防止旧部署与新部署竞争。
- 默认 URL 为 `https://camillehe1992.github.io/`。
- HTTPS、重定向、404、RSS、sitemap 和 canonical URL 已验证通过。

### 发布后检查

```sh
curl -I https://camillehe1992.github.io/
curl -I https://camillehe1992.github.io/not-a-real-page/
curl -fsSL https://camillehe1992.github.io/index.xml
curl -fsSL https://camillehe1992.github.io/sitemap.xml
curl -fsSL https://camillehe1992.github.io/ | tr '>' '>\n' | grep -i canonical
```

应确认主页可访问、错误页返回 404、RSS 和 sitemap 返回有效内容，并且
canonical URL 使用默认用户站点 URL。

## 7. 质量自动化

### 必需检查

CI 已覆盖或配置了：

- Hugo production build。
- Markdown lint。
- YAML lint。
- GitHub Actions syntax 检查。
- Markdown-aware 和 generated-site link 检查。
- Pull Request validation workflow。
- 非敏感的 PR summary。

本地完整检查命令见 [CONTENT_GUIDE.md](CONTENT_GUIDE.md) 的 Local publishing
workflow；提交前额外运行 `git diff --check`。本地需要 Node.js 22、`yamllint`
和 `actionlint`；Node.js 18 可能无法运行当前锁定的 Markdown 工具链。

## 8. 变更验收标准

每次重要变更至少完成：

- [ ] 干净 checkout 能使用文档化、固定版本工具构建。
- [ ] 所有内容和配置变更可通过 Git review。
- [ ] PR 能捕获构建、格式、链接和敏感信息问题。
- [ ] 只有已验证的生产输出会部署到 GitHub Pages。
- [ ] 核心页面可访问，导航、搜索、RSS、sitemap 和 canonical 正常。
- [ ] 桌面、移动、暗色模式和无障碍表现已检查。
- [ ] 源码、artifact、日志和生成页面不包含凭据、私钥或敏感基础设施信息。
- [ ] 主题升级、文章发布、回滚和本地开发流程有文档记录。
- [ ] 方案保持低成本、低维护，不引入不必要的后端基础设施。
