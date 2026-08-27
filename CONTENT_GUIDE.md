# Content Authoring Guide

This guide defines the Phase 5 workflow for technical articles. Content lives in
`content/` and is reviewed as Markdown; generated `public/` output is not committed.

## Content structure

Posts are grouped by primary subject:

```text
content/posts/
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
Descriptions are metadata; summaries are reader-facing previews. Set
`draft: false` only after review.

Configured categories are AWS, Terraform, CloudFormation, DevOps, Security,
AI, and RAG. Use tags for concrete technologies such as EC2, VPC, IAM,
Kubernetes, GitHub Actions, CI/CD, LLM, and Vector Database. Hugo's standard
taxonomies are enabled in `config/_default/hugo.yaml` and rendered by Blowfish.

## Article structure

Use the archetype headings as a flexible starting point: Overview, Background,
Architecture / Design, Implementation, Configuration Examples, Validation,
Lessons Learned, and References. Remove sections that do not serve the article.

## Visuals

Use page bundles for article-specific images:

```text
content/posts/aws/example/
├── index.md
└── architecture.svg
```

This keeps diagrams beside the article and avoids filename collisions. Use
`static/images/` only for site-wide assets. Prefer versioned SVG or optimized
PNG diagrams; introduce Mermaid only after local and production rendering is
verified. Every visual needs alt text, and third-party visuals need attribution.

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

Put command output in `text` blocks, explain non-obvious flags, and show the
expected validation result. Hugo Goldmark and Blowfish provide highlighting and
code-copy controls.

## Local publishing workflow

1. Create a draft: `hugo new posts/<topic>/<slug>.md`.
2. Edit front matter and sections; add page-bundle visuals if needed.
3. Preview drafts with `hugo server -D`.
4. Review links, code, spelling, accessibility, mobile layout, and sensitive values.
5. Run `hugo --minify` and confirm the build succeeds.
6. Set `draft: false`, review once more, and commit the source.
7. Publish through the reviewed Git workflow. CI/CD is out of scope for Phase 5.

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

Resume/CV, analytics, a custom domain, comments/newsletter, and AI-assisted publishing are deferred until there is real content and clear operational ownership. The current site remains deployable through the existing GitHub Pages workflow.
