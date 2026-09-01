# Content Authoring Guide

[中文](CONTENT_GUIDE.zh.md) ｜ [English](CONTENT_GUIDE.md)

This guide defines the current workflow for technical articles and portfolio
content. Content is organized per language: English under `content/en/` and
Simplified Chinese under `content/zh-cn/`, with identical relative paths so
Hugo pairs translations automatically. Content is reviewed as Markdown;
generated `public/` output is not committed. Site-wide deployment and
maintenance rules are documented in the
[Website Maintenance Guide](WEBSITE_MAINTENANCE_GUIDE.md)
｜ [中文](WEBSITE_MAINTENANCE_GUIDE.zh.md).

## Content structure

Posts are grouped by primary subject:

```text
content/en/posts/          (English source; Chinese mirrors under content/zh-cn/posts/)
├── aws/
├── terraform/
├── cloudformation/
├── devops/
├── security/
└── ai/
```

`rag` remains a topic within `ai` rather than a separate section for now. This
keeps navigation compact while `categories: [AI, RAG]` still makes RAG work
discoverable. Each section has an `_index.md` for a stable list page. Use
lowercase kebab-case filenames.

## Front matter

`archetypes/posts.md` provides YAML front matter compatible with Blowfish:

```yaml
title: "Short, specific title"
date: 2026-08-27T09:00:00+08:00
draft: true
description: "A concise search and metadata description."
summary: "The article's short list and card summary."
categories: [AWS]
tags: [IAM, Security]
author: "Camille He"
featuredImage: ""
featuredImageAlt: ""
series: []
```

Use `featuredImage` and `featuredImageAlt` together. `series` is optional.
`date` is filled in by the archetype from the local creation time; set it
deliberately. Descriptions are metadata; summaries are reader-facing previews.
Set `draft: false` only after review.

Use the following categories consistently, matching the section structure:
AWS, Terraform, CloudFormation, DevOps, Security, AI, and RAG. Use tags for
concrete technologies such as EC2, VPC, IAM, Kubernetes, GitHub Actions,
CI/CD, LLM, and Vector Database. Hugo's standard taxonomies are enabled in
`config/_default/hugo.yaml` and rendered by Blowfish.

## Article structure

Use the archetype headings as a flexible starting point: Overview, Background,
Architecture / Design, Implementation, Configuration Examples, Validation,
Lessons Learned, and References. Remove sections that do not serve the article.
Use the theme-provided H1 for the page and start the body with H2 headings.
Do not write `## Contents` manually in the body; the site generates a
navigation TOC from H2-H4 headings in the desktop sidebar and the mobile
collapsible section.

## Visuals

Use page bundles for article-specific images:

```text
content/en/posts/aws/example/
├── index.md
└── architecture.svg
```

This keeps diagrams beside the article and avoids filename collisions. Use
`static/images/` only for site-wide assets. Resources Hugo must process live
in `assets/`; directly published assets such as favicons, downloads, and stable
images live in `static/`. The profile layout currently uses
`assets/img/author.png`. Prefer versioned SVG or optimized PNG diagrams;
introduce Mermaid only after local and production rendering is verified. Every
visual needs alt text, and third-party visuals need attribution. Diagrams
support the prose rather than replace it, and must not depict systems,
metrics, or projects that do not exist.

## Technical formatting

Use fenced blocks with language identifiers: `hcl` for Terraform, `sh` for AWS
CLI, `yaml` for configuration, `python` for Python, and `json` for JSON. Mark
placeholders explicitly, for example `<your-aws-profile>` or `${YOUR_ACCOUNT_ID}`;
never use real credentials or private identifiers.

```hcl
resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
}
```

Put command output in `text` blocks. State prerequisites, key parameters, and
expected results for commands, explain non-obvious flags, and show the expected
validation result. Hugo Goldmark and Blowfish provide highlighting and
code-copy controls.

## Local publishing workflow

1. Create a draft with `hugo new posts/<topic>/<slug>.md`; use
   `hugo new posts/<topic>/<slug>/index.md` when the article needs page-bundle
   visuals.
2. Edit front matter and sections; add page-bundle visuals if needed.
3. Preview drafts with `hugo server -D`.
4. Review links, code, spelling, accessibility, mobile layout, and sensitive values.
5. Run `hugo --minify --panicOnWarning` and confirm the build succeeds.
6. Run the repository quality gates when Node.js 22, `yamllint`, and
   `actionlint` are available.
7. Set `draft: false`, review once more, and open a Pull Request.
8. Publish by merging the reviewed change to `main`; GitHub Actions deploys the
   validated Pages artifact.
9. After merge, verify the live pages, assets, RSS, sitemap, canonical URLs, and
   404 page.

The short-version local commands are:

```sh
hugo server --buildDrafts
hugo --minify
npm ci
npm run lint:markdown
yamllint -c .yamllint .github config
hugo --minify --panicOnWarning
npm run check:links

# Complete CI-equivalent quality gate (requires yamllint and actionlint)
.github/scripts/validate-quality.sh

# Optional fast checks before committing
pre-commit run --all-files
```

## Editorial checklist

- [ ] Front matter is complete and the date is intentional.
- [ ] Claims, commands, AWS behavior, and provider versions are accurate.
- [ ] No credentials, private keys, account IDs, or sensitive values are present.
- [ ] Code blocks have language identifiers, safe placeholders, and validation steps.
- [ ] Links resolve and references favor official documentation.
- [ ] Images have alt text, acceptable size, and attribution where required.
- [ ] Headings are ordered, prose is clear, and the page works on mobile.
- [ ] The draft was previewed and the production build succeeds.

## Portfolio conventions

Portfolio pages use the following reusable structure:

- **Project cards:** lead with the problem and outcome, then list architecture, technologies, security, cost, repository, and learnings.
- **Technology tags:** use short, stable names such as `AWS`, `Terraform`, `GitHub Actions`, `Security`, and `RAG`; reserve tags for concrete technologies or themes.
- **Architecture showcases:** pair a real, shareable diagram with concise boundary, automation, and trade-off decisions. Do not invent systems, metrics, or diagrams.
- **Featured articles:** link to published posts only after the article has passed the editorial checklist; the homepage can surface recent writing through the existing Blowfish profile layout.
- **GitHub links:** add repository URLs manually to published case studies. The site intentionally does not call the GitHub API.
