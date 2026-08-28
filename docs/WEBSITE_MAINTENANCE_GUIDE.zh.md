# 个人技术网站维护规范

[中文](WEBSITE_MAINTENANCE_GUIDE.zh.md) ｜ [English](WEBSITE_MAINTENANCE_GUIDE.md)

本文档是维护 `https://camillehe1992.github.io/`（GitHub Pages 默认用户站点）
的操作规范。文章创作与发布约定见 [CONTENT_GUIDE.md](CONTENT_GUIDE.md) ｜
[中文](CONTENT_GUIDE.zh.md)。

本指南区分三种状态：

- **已完成（Complete）：** 有当前仓库或公开站点证据支持。
- **待完成（Outstanding）：** 尚未实现。
- **未验证（Unverified）：** 需要仓库访问、线上环境访问或更广泛的设备测试。

## 1. 当前站点边界

关于技术栈、Hugo Modules 集成、Pages URL 和部署模型的已确认事实见
[README.md](../README.md)（Prerequisites、Configuration notes、Repository
conventions），本指南不再重复。

### 未验证或不在范围内

- 自定义域名、DNS 和 CNAME 配置不在当前项目范围内。
- GitHub 仓库的分支保护规则和 required checks 尚未在仓库设置中记录。
- GitHub Actions 的完整部署历史不是本地仓库证据的一部分。
- 移动端断点、真实设备表现和 Lighthouse 分数尚未完成系统验证。
- 社交账号 URL、头像、所在地和公开联系方式尚未提供，不应自行补充。
- Analytics、评论、Newsletter 和复杂 AI 辅助发布流程暂不启用。

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

### 尚未完成或未确认

- [ ] 在 GitHub 仓库中保护 `main`，并要求 PR 必须通过必要检查后才能合并。
- [ ] 将实际 required checks 名称记录到仓库文档中。
- [ ] 确认默认分支、分支保护和 Actions 权限设置与当前工作流一致。

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

### 尚未完成或未确认

- [ ] 补充真实头像、logo、默认社交图片和公开 profile 链接。
- [ ] 验证暗色和浅色模式下代码、表格、图片和未来图表的显示效果。
- [ ] 完成移动设备和不同响应式断点的实际检查。
- [ ] 确认搜索不会索引 draft 或私有内容。
- [ ] 维护 SEO title template、Open Graph 图片和结构化数据的专项检查。
- [ ] 记录自定义 CSS 和 layout override 的命名、范围和维护说明。

## 5. 内容发布规范

文章创建、front matter、技术格式、图片、发布流程和当前内容状态见
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

当前已确认：

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

### 尚未完成或未确认

- [ ] 记录最近一次成功的 Actions 部署运行 ID 和部署时间。
- [ ] 记录 `github-pages` Environment 保护规则是否要求 required reviewers。
- [ ] 在真实移动设备上完成发布后检查。
- [ ] 补充回滚操作记录：回滚源代码变更并通过正常 workflow 重新部署。

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

### 尚未完成或未确认

- [ ] 加入拼写检查和 AWS/技术术语 allowlist。
- [ ] 加入正式 pre-commit hooks；目前仅作为可选快速检查规划。
- [ ] 增加定期外部链接和依赖检查。
- [ ] 增加 Lighthouse 或等效性能/无障碍审计。
- [ ] 增加生成 HTML 校验。
- [ ] 增加自动图片优化。
- [ ] 评估 Dependabot 或 Renovate。
- [ ] 增加适合公开仓库的 secret/sensitive-value scanning。

## 8. 专业功能维护状态

### 已完成或已具备

- About、Projects、Posts 页面和核心导航。

### 未完成或暂缓

- [ ] Resume/CV 页面或可下载 PDF。
- [ ] 真实项目案例：架构图、角色说明、成果和 repository/demo links。
- [ ] 真实 profile/contact links。
- [ ] 评论系统及 moderation/privacy 规则。
- [ ] Newsletter provider、consent、unsubscribe 和数据保留策略。
- [ ] Analytics；必须先确定隐私策略和维护责任人。

## 9. 未来功能规划

按低风险、低维护优先级排序：

1. 发布真实技术文章和项目案例，并补充可公开的仓库链接。
2. 在内容准备好后增加 Resume/CV 页面。
3. 完成移动端、Lighthouse、HTML 和无障碍专项审计。
4. 根据维护价值选择拼写、依赖、外链和图片自动化。
5. 评估构建时 GitHub 项目数据，避免客户端实时 API 依赖。
6. 如有真实需求，再评估 AI 辅助草稿、引用检查、架构图生成和发布摘要；必须保留人工 review、引用验证和 secret filtering。
7. 只有明确需要时才评估 Analytics、评论、Newsletter 或社交媒体发布。
8. 自定义域名、Cloudflare DNS、缓存和安全服务均不在当前默认 URL 方案内；未来若改变托管策略，应另开独立变更并重新验证 HTTPS、canonical 和 DNS。

## 10. 变更验收标准

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

## 11. 当前未完成事项汇总

以下项目在满足条件前不要标记为完成：

- GitHub 仓库分支保护和 required checks 的实际设置记录。
- Actions 部署历史和 `github-pages` Environment 保护规则的维护记录。
- 真实头像、社交链接、profile/contact links 和公开履历信息。
- Resume/CV 页面或 PDF。
- 真实项目案例、架构图、指标和仓库链接。
- dated technical articles，尤其是准备公开发布的代表性文章。
- 移动端真实设备、Lighthouse、HTML 和专项无障碍验证。
- 拼写、secret scanning、pre-commit、定期依赖/外链检查和图片优化。
- 评论、Newsletter、Analytics 和 AI-assisted publishing 的隐私与运营方案。
- 自定义域名、DNS 和 CNAME；当前默认用户站点不需要这些配置。
