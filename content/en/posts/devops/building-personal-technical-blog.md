---
title: "Building a Personal Technical Blog with Hugo, Blowfish and GitHub Pages"
date: 2026-08-31T10:15:00+08:00
draft: false
description: "How I designed and built my personal technical blog as a small engineering project using Hugo, Blowfish, GitHub Pages, and GitHub Actions."
summary: "A case study in treating a personal blog as a small engineering project: Hugo and Blowfish static site generation, phased implementation, GitHub Actions quality gates, and GitHub Pages deployment."
categories: [DevOps]
tags: [Hugo, Blowfish, GitHub Pages, GitHub Actions, CI/CD, AI Coding]
author: "Camille He"
featuredImage: ""
featuredImageAlt: ""
series: []
slug: building-personal-technical-blog
---

## Introduction

This site is my personal technical blog, and it is also the subject of its first article. When I started it in late August 2026, I wanted it to be more than a place to publish articles. The blog is meant to work as:

- A technical knowledge base that I can reuse and extend.
- A Cloud/DevOps engineering portfolio that shows how I work.
- A place to record engineering decisions and lessons learned.
- A practical example of applying modern development and automation practices to a small, real project.

This article describes the engineering approach behind the site: the requirements, the technology choices, the phased implementation, and the automation that now validates and deploys it.

## Why Build the Blog as an Engineering Project?

The central decision was to treat the blog as a small engineering project instead of simply installing a blogging platform and starting to write. Blogging platforms make publishing easy, but they also take most operational and architectural decisions out of my hands — which is exactly what I wanted to practice on this site.

Treating the project this way does not mean treating it as production infrastructure. The scope is a personal site, and the ambition is deliberately modest. The point is to apply the same habits:

- **Infrastructure as code mindset** — the site's configuration and content are declarative files in a repository.
- **Version control** — every change is a reviewable commit with a clear history.
- **Reproducible builds** — a pinned Hugo version and a theme pinned as a module dependency.
- **Automated validation** — linting and build checks run before changes are merged.
- **CI/CD** — validation, building, and deployment are automated rather than manual.
- **Incremental implementation** — work is split into small phases that can be reviewed and validated independently.
- **Documentation** — the workflows for writing, maintaining, and deploying the site are documented in the repository.
- **Maintainability** — dependencies and tooling are kept small so the site stays cheap to operate and easy to change.

## Requirements and Goals

The architecture grew out of a small set of requirements:

- Markdown-based authoring, so content stays plain text and diff-friendly.
- Static site generation, so the site is a set of files to host rather than a server to run.
- Git-based content management, with the repository as the single source of truth.
- Low operational cost and simple hosting.
- Automated deployment through existing CI.
- Maintainable theme management, so theme upgrades do not become a project.
- Professional technical presentation, including highlighted code, search, dark mode, and clean list pages.
- Support for technical diagrams and code examples in articles.
- Room to evolve into a portfolio as real projects are published.

Some ideas that are often part of a "personal blog" setup were explicitly not requirements at the start: a custom domain, comments, analytics, a newsletter, or a résumé page. They are documented as deferred in the repository rather than half-implemented, because each one adds ownership cost. Treating requirements as a deliberate list made later decisions — especially where to invest in automation — much easier.

## Architecture

The architecture is intentionally simple: a developer pushes content to GitHub, GitHub Actions validates and builds the site, and GitHub Pages serves the generated files.

```text
Developer
    |
    | Git Push
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    +--> Quality Gates
    |
    +--> Hugo Production Build
    |
    v
GitHub Pages
    |
    v
Personal Technical Blog
```

The repository is the single source of truth: content, configuration, and workflow definitions all live in Git. GitHub Actions is the only automation layer. Quality gates run on pull requests; the production build runs on the main branch; the built `public/` directory is uploaded as a Pages artifact and deployed. There is no database, no application server, and no third-party build service.

The current repository does not use Mermaid diagrams. Mermaid rendering must be verified locally and in production before it is introduced, so this article uses an ASCII diagram instead; Mermaid support is planned future work.

## Technology Choices

### Hugo

Hugo is a static site generator: it turns Markdown content and configuration into a set of HTML files. It fits the requirements directly — Markdown-based authoring, fast builds for local preview, and low operational complexity. The project uses [Hugo Extended](https://gohugo.io/) `0.165.0`, recorded in `.hugo-version` and pinned in the CI workflows.

### Blowfish

Blowfish is the theme. The main reasons I chose it: it is designed for content-focused personal sites, it is actively maintained, and it provides the features this project needs out of the box — a profile homepage, list and card layouts, search, dark mode, code copy, taxonomies, and accessibility options. The theme is integrated as a Hugo module pinned at [v3.4.0](https://blowfish.page/) in `go.mod`/`go.sum`, so upgrades are a version change rather than a patch file. Customization is kept in site configuration and small overrides instead of editing theme files.

### GitHub

GitHub is the collaboration and automation hub. The repository holds everything, pull requests are the review mechanism for content and configuration changes, and GitHub Actions runs in the same place as the review. The project also happens to live at the default GitHub Pages user-site address, which makes the integration natural. The source repository is [camillehe1992/camillehe1992.github.io](https://github.com/camillehe1992/camillehe1992.github.io).

### GitHub Pages

GitHub Pages serves the site at the default user-site URL <https://camillehe1992.github.io/>. It is static hosting with very low operational overhead: no server to manage, and hosting that is free for a public user site. An important detail is how the site is deployed: Pages Source is set to GitHub Actions, so publishing goes through a validated artifact uploaded by CI using OpenID Connect (OIDC), rather than branch-based publishing. Only the production-built `public/` directory is uploaded.

### GitHub Actions

GitHub Actions provides the validation, build, and deployment pipeline. Pull requests run the quality gates, pushes to `main` are validated, and the Pages artifact is built and deployed from `main`. Workflows use the minimal permission scope needed (`contents`, `pages`, `id-token`), and concurrency controls prevent old deployments from racing new ones.

### AI Coding Agent

An AI coding agent was used as an implementation assistant throughout the project. It helped scaffold the initial structure, produce configuration and documentation drafts, and implement small, well-defined tasks phase by phase. The important boundary: AI was used as an implementation and productivity tool, while architecture, scope, and engineering decisions remained under human review. The agent's output was treated like any other contribution — it had to be reviewed, validated, and committed through the normal Git workflow. The project was deliberately implemented incrementally so that AI-generated changes stayed small enough to review.

## Phased Implementation Strategy

The implementation was split into ten phases. The phase list below is the primary implementation structure: it is supported by the Git history, but phase boundaries do not map one-to-one to commits or pull requests. Each phase had a clear objective, was separated so it could be reviewed and validated on its own, and produced a checkable outcome.

### Phase 1 — Project Bootstrap

- **Objective:** create a repository skeleton and record the plan before building anything.
- **Why separate:** scaffolding and planning should not be mixed with implementation; it gives version control and a documented starting point.
- **Outcome:** initialized the repository with `.editorconfig`, `.gitignore`, a README, and the empty directory structure for the site (`archetypes/`, `assets/`, `config/`, `content/`, `data/`, `layouts/`, `static/`).

### Phase 2 — Hugo Core Setup

- **Objective:** get a minimal Hugo site building locally.
- **Why separate:** confirm the toolchain works before adding a theme.
- **Outcome:** Hugo project setup with Hugo Extended `0.165.0` recorded in `.hugo-version`.

### Phase 3 — Blowfish Theme Integration

- **Objective:** replace hand-written templates with a maintained theme.
- **Why separate:** theme integration changes the site's structure and should be isolated from content work.
- **Outcome:** Blowfish v3.4.0 integrated as a Hugo module pinned in `go.mod`/`go.sum`, and the temporary custom layouts removed.

### Phase 4 — Site Configuration and Personal Branding

- **Objective:** configure the site as a personal profile instead of a bare Hugo site.
- **Why separate:** branding and navigation decisions affect everything that follows.
- **Outcome:** site foundation configuration (`hugo.yaml`, `params.yaml`, language and menu files), a profile homepage, and Home/Posts/Projects/About navigation.

### Phase 5 — Content Structure and Authoring Workflow

- **Objective:** define how articles are created, formatted, and reviewed.
- **Why separate:** consistent authoring conventions are needed before the first article exists.
- **Outcome:** a posts archetype (`archetypes/posts.md`), per-section `_index.md` pages under `content/posts/` (aws, terraform, cloudformation, devops, security, ai), and a content guide documenting front matter, visuals, formatting, and the publishing workflow.

### Phase 6 — GitHub Actions CI Validation

- **Objective:** validate the site before changes are merged.
- **Why separate:** validation should be in place before content and configuration accumulate.
- **Outcome:** pull-request and main-branch workflows that run the Hugo production build (`hugo --minify --panicOnWarning`).

### Phase 7 — GitHub Pages Deployment

- **Objective:** automate publishing.
- **Why separate:** deployment is the delivery boundary; automating it makes every merge a potential publish.
- **Outcome:** a deployment workflow that configures GitHub Pages, uploads the built `public/` directory as an artifact, and deploys it with OIDC under the `github-pages` environment.

### Phase 8 — Quality Automation and Validation

- **Objective:** broaden validation from a single build to a set of quality gates.
- **Why separate:** lint and link checks catch issues the build cannot, and they should run in CI, not only locally.
- **Outcome:** a shared quality script (`.github/scripts/validate-quality.sh`) running Markdown lint, YAML lint, GitHub Actions syntax checks, the Hugo production build, and a generated-site link check, plus the related lint and pre-commit configuration.

### Phase 9 — Professional Portfolio Enhancements

- **Objective:** present the site as a credible engineering portfolio, not just a blog.
- **Why separate:** portfolio presentation needs design decisions about content structure, not more scaffolding.
- **Outcome:** a profile homepage with an author image, About and Projects pages with honest case-study conventions and placeholders, and design and plan documentation under `docs/superpowers/`.

### Phase 10 — Multi-language Support

- **Objective:** publish in both English and Simplified Chinese.
- **Why separate:** per-language content layout and navigation changes should not be mixed with writing the first articles.
- **Outcome:** Hugo multilingual configuration with `languages.en.yaml` and `languages.zh-cn.yaml`, per-language content directories (`content/en/`, `content/zh-cn/`) with identical relative paths so Hugo pairs translations automatically, and a Simplified Chinese menu.

## Using an AI Coding Agent

The project was implemented incrementally rather than asking an AI coding agent to build everything in one step. The process that emerged was:

1. **Planning first.** Each piece of work started from a written plan or spec that defined the objective and the boundaries, not from a vague request.
2. **Maintaining a checklist.** Tasks were tracked as explicit items so progress and remaining work stayed visible.
3. **Executing one phase at a time.** Each phase was scoped to a small, reviewable change.
4. **Reviewing AI-generated changes.** The agent's output was read and verified like any other contribution; it was never assumed to be correct.
5. **Creating Git checkpoints.** Each completed piece was committed separately, giving clean recovery points.
6. **Validating before continuing.** Builds and quality checks ran at phase boundaries, so problems were caught early.

The advantages were practical: scaffolding, configuration, and documentation drafts were produced quickly, and small tasks could be delegated with precise instructions. The limitations were equally practical: AI output needs verification, context must be handed over explicitly, and the agent cannot make project-level decisions. Keeping the human in charge of architecture, scope, and engineering decisions was a deliberate choice, not an accident of the workflow.

## CI/CD and Quality Gates

The conceptual delivery flow is:

```text
Pull Request
    |
    v
Quality Gates
    |
    +--> Markdown lint
    +--> YAML lint
    +--> GitHub Actions syntax check
    +--> Hugo production build
    +--> Generated-site link check
    |
    v
Merge
    |
    v
Main
    |
    v
GitHub Pages Deployment
```

The checks that actually exist in the repository:

- **Markdown lint** — `markdownlint-cli2` via `npm run lint:markdown`.
- **YAML lint** — `yamllint` on `.github` and `config`.
- **GitHub Actions syntax** — `actionlint`.
- **Hugo production build** — `hugo --minify --panicOnWarning`.
- **Generated-site link check** — `linkinator` over the built `public/` directory.

The workflows are:

- `.github/workflows/validate-pr.yml` runs the quality gates on pull requests and publishes a non-sensitive validation summary.
- `.github/workflows/validate-main.yml` builds the site on pushes to `main`.
- `.github/workflows/deploy-pages.yml` builds the production site, uploads the Pages artifact using `actions/configure-pages` and `actions/upload-pages-artifact`, and deploys with `actions/deploy-pages` using OIDC and the `github-pages` environment.

One distinction is worth calling out: `npm run check:links` (a Markdown link check over README and docs) is a local-only check; it is not part of CI. Checks that are not implemented — such as spell checking, secret scanning, scheduled checks, or Lighthouse audits — are future work, not current gates.

## Lessons Learned

- **Planning before implementation reduces rework.** The small written plans were cheap to produce and saved far more time than they cost, because each phase started with a clear objective and boundary.
- **Small phases make AI-assisted development easier to review.** A one-commit change that touches one concern can be verified quickly; a large generated diff cannot.
- **Git commits provide useful recovery points.** Because every phase ended in a commit, it was always possible to inspect, compare, or revert a specific step.
- **CI/CD should be introduced early.** The validation and deployment workflows were added before the first article existed, which means content changes have been checked automatically from the start.
- **Theme and dependency management should be treated as project dependencies.** Pinning Blowfish as a Hugo module and recording the Hugo version in the repository turned "theme maintenance" from an unknown risk into a routine version change.
- **A personal website is a practical engineering sandbox.** It is small enough to change quickly, real enough to be honest, and visible enough to motivate good practices.

## What's Next

The following are planned improvements, not implemented features:

- **More technical articles and project case studies.** The content sections are ready; the projects section still shows placeholders until real implementations are ready to share.
- **Better portfolio presentation.** For example, linking published case studies to their repositories manually, without a GitHub API integration.
- **Verify Mermaid rendering** locally and in production before introducing Mermaid diagrams; this article uses ASCII for that reason.
- **SEO improvements** and a **custom domain**, which are deferred because they add ownership and configuration cost.
- **Privacy-friendly analytics**, only if the value justifies the added tracking.
- **Additional quality automation**, such as spell checking, secret scanning, scheduled checks, and Lighthouse audits.
- **AI-assisted content workflows**, such as draft review and consistency checks, once the manual process has proven itself.

## Conclusion

This blog is both a publishing platform and an evolving engineering project. The infrastructure behind it is deliberately small, the automation is deliberately early, and the decisions are recorded in the repository. This article is the beginning of the content, not the end of the project.
