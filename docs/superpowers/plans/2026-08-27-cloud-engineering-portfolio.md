# Cloud Engineering Portfolio Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the existing Hugo + Blowfish blog into a maintainable, honest cloud engineering portfolio.

**Architecture:** Preserve the current theme, content sections, navigation, and Pages workflows. Express portfolio structure in Markdown content and existing Blowfish configuration, with no new dependencies or external APIs.

**Tech Stack:** Hugo Extended 0.165.0, Blowfish 3.4.0, Markdown, existing shell quality automation.

---

### Task 1: Portfolio content and discovery

**Files:**
- Modify: `content/_index.md`
- Modify: `content/about/_index.md`
- Modify: `content/projects/_index.md`
- Modify: `config/_default/params.yaml`

- [ ] Replace placeholder homepage copy with a concise professional value proposition, focus areas, project path, and featured-content guidance without personal claims beyond the supplied identity and interests.
- [ ] Write About page sections for introduction, technical focus, engineering philosophy, and interests, using placeholders only for unavailable profile/contact details.
- [ ] Write Projects page with reusable case-study fields and honest project-status labels; include architecture, security, cost, technologies, repository placeholder, and key-learnings prompts.
- [ ] Add homepage profile links for Projects and About using existing Blowfish parameters.

### Task 2: Navigation and portfolio conventions

**Files:**
- Modify: `config/_default/menus.en.yaml`
- Modify: `content/projects/_index.md`
- Modify: `CONTENT_GUIDE.md`

- [ ] Keep navigation limited to Home, Posts, Projects, and About, with accessible labels and stable page references.
- [ ] Add documentation for technology tags, project cards, architecture showcases, featured articles, and manual GitHub links.
- [ ] Document why resume, analytics, custom domain, comments/newsletter, and AI-assisted publishing remain deferred.

### Task 3: Verify the site and regression boundaries

**Files:**
- Test: generated Hugo output and existing `.github/workflows/*.yml`

- [ ] Run `hugo --minify` and inspect generated homepage, About, Projects, RSS, sitemap, and navigation links.
- [ ] Run the repository quality script and `git diff --check`.
- [ ] Confirm deployment workflow files are unchanged and record any environment-only Pages verification limitation.
