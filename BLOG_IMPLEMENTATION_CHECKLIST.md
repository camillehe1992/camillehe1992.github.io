# Personal Technical Blog Implementation Checklist

> Source of truth for implementing a professional, maintainable engineering blog on Hugo, Blowfish, and GitHub Pages.

## Project goals and constraints

- [ ] Publish a long-term technical portfolio focused on AWS Cloud Architecture, Infrastructure as Code, DevOps and CI/CD, GitHub Actions, Cloud Security, AI Engineering, and RAG applications.
- [ ] Use Hugo with the Blowfish theme and Markdown content.
- [ ] Host the generated static site on GitHub Pages.
- [ ] Treat the repository as a GitOps-style, production-quality project: changes are reviewed, versioned, validated, and deployed through Git.
- [ ] Prefer free or low-cost services and avoid infrastructure that creates ongoing operational maintenance.
- [ ] Keep the first release simple enough to operate alone and extensible enough for future portfolio features.

## 1. Project architecture

### Logical architecture

The source repository is the single source of truth. Hugo reads site configuration, theme configuration, content, layouts, static assets, and data files, then produces a static `public/` directory. GitHub Actions validates and builds the site on pull requests and deploys the generated artifact to the GitHub Pages environment after an approved change reaches the deployment branch.

Blowfish supplies the presentation layer and reusable templates. Site-specific configuration, content, assets, and overrides remain in the repository so the theme can be upgraded without modifying vendor files. GitHub Pages serves only the generated static output; no application server, database, or runtime backend is required.

### High-level architecture diagram description

```text
Author
  │ creates or edits Markdown, configuration, and assets
  ▼
Feature branch ── Pull Request ──► GitHub Actions: lint + Hugo build + link checks
  │                                      │
  └──────── merge to deployment branch ◄─┘
                         │
                         ▼
              GitHub Actions: production Hugo build
                         │
                         ▼
              GitHub Pages deployment environment
                         │
                         ▼
                    Public website
```

### Workflows

- [ ] Local development: install Hugo Extended, clone the repository, initialize the theme dependency, run `hugo server --buildDrafts`, and preview changes locally.
- [ ] Content publishing: create a dated Markdown page, add validated front matter, write and preview the article, run local quality checks, open a pull request, and publish after merge.
- [ ] CI/CD: run fast validation on pull requests; build and deploy only from the protected deployment branch.
- [ ] Operations: keep GitHub Pages, Actions, repository settings, domain configuration, and third-party integrations documented in the repository.

## 2. Phased implementation plan

### Phase 1–7 readiness audit — 2026-08-27

This audit was completed before starting Phase 8. Status is based on the
repository contents, Git history, local Hugo builds, and the available local
workflow files. GitHub repository settings and Actions deployment history were
not available from the current environment, so remote-only checks remain
explicitly unverified.

| Phase | Status | Evidence and remaining work |
| --- | --- | --- |
| 1. Project initialization | Complete | Repository structure, baseline documentation, Git ignore rules, and generated-output policy are present. History includes the repository initialization commits. |
| 2. Hugo setup | Complete | Hugo Extended `0.165.0`, site configuration, content structure, and successful local production builds are present. |
| 3. Blowfish integration | Complete | Blowfish v3.4.0 is pinned through Hugo Modules in `go.mod`, `go.sum`, and `config/_default/module.toml`; local builds load the theme. |
| 4. Site configuration | Partially complete | Site identity, navigation, taxonomy, responsive theme behavior, metadata, RSS, sitemap, and robots output are present. Social links and optional search/analytics decisions remain incomplete or intentionally deferred. |
| 5. Content workflow | Complete | `CONTENT_GUIDE.md`, `archetypes/posts.md`, content sections, and editorial conventions are present; the local build succeeds. |
| 6. GitHub Actions CI/CD | Partially complete | PR/main Hugo validation and Pages deployment workflows are present. Markdown, YAML, and Markdown-aware link validation are not yet implemented, so the full Phase 6 checklist is not complete. |
| 7. GitHub Pages deployment | Partially complete | `.github/workflows/deploy-pages.yml` uses the build → Pages artifact → deployment flow, and `baseURL` is configured for the user site. Pages source, environment settings, deployment history, and public smoke checks require GitHub access and remain unverified. |

**Phase 8 readiness:** Do not mark Phases 1–7 fully complete yet. Phase 8 may
be designed, but its entry criteria should track the Phase 6 quality-gate gaps
and the remote Phase 7 verification items above.

### Phase 1 — Project initialization and repository structure

**Objective:** Establish a clean, documented Hugo repository boundary.

**Tasks**

- [ ] Confirm repository name, GitHub Pages project-site versus user-site URL, default branch, and ownership.
- [ ] Verify Hugo Extended version compatibility with the selected Blowfish release.
- [ ] Create the Hugo directory layout and baseline documentation.
- [ ] Add `.gitignore`, `.editorconfig`, and a concise `README.md` covering prerequisites and local commands.
- [ ] Decide whether generated output is deployed as an artifact rather than committed to the source branch.

**Deliverables:** repository skeleton, documented prerequisites, baseline conventions.

**Dependencies:** GitHub repository access; Hugo version decision.

**Validation:** Hugo can be invoked locally; repository contains no generated or secret files; README commands are internally consistent.

### Phase 2 — Hugo setup

**Objective:** Create a working Hugo site with predictable build behavior.

**Tasks**

- [ ] Initialize the site with a versioned Hugo configuration.
- [ ] Select the Extended edition because Blowfish and future content may require asset processing.
- [ ] Configure `baseURL`, language, time zone, title, description, and build output assumptions.
- [ ] Add a minimal home page and one representative post.
- [ ] Define draft behavior for local preview versus production builds.

**Deliverables:** Hugo site that renders locally and builds to `public/`.

**Dependencies:** Phase 1; Hugo Extended.

**Validation:** `hugo --minify` succeeds from a clean checkout and produces a complete static site.

### Phase 3 — Blowfish theme integration

**Objective:** Integrate Blowfish with reproducible version management.

**Tasks**

- [ ] Compare Hugo Modules and Git submodules using the strategy below.
- [ ] Pin the theme to a known release or commit; do not track an unbounded branch.
- [ ] Add only the theme configuration required for the initial site.
- [ ] Confirm theme assets are included in both local and CI builds.
- [ ] Document the theme upgrade procedure and compatibility checks.

**Deliverables:** pinned Blowfish integration and upgrade notes.

**Dependencies:** Phase 2; Go/Hugo module tooling if Hugo Modules are selected.

**Validation:** clean checkout builds without manually copying theme files; a test page renders with Blowfish layouts.

### Phase 4 — Site configuration and customization

**Objective:** Establish a recognizable, professional information architecture.

**Tasks**

- [ ] Configure site identity, author profile, avatar, bio, location, and social links.
- [ ] Design the homepage around recent writing, technical focus areas, featured projects, and a clear About path.
- [ ] Configure primary navigation for Home, Posts, Projects, About, and optional Resume.
- [ ] Define categories and tags; keep taxonomy names stable and human-readable.
- [ ] Enable dark mode, responsive behavior, accessible contrast, keyboard navigation, and code copy controls.
- [ ] Enable search using the lowest-maintenance Blowfish-supported option.
- [ ] Configure SEO metadata, canonical URLs, Open Graph/Twitter cards, RSS, sitemap, and robots behavior.
- [ ] Decide whether privacy-respecting analytics are needed; keep analytics optional and documented.

**Deliverables:** configured visual identity, navigation, taxonomy, search, and metadata.

**Dependencies:** Phase 3; author and branding content.

**Validation:** homepage and core pages work at desktop and mobile widths; metadata and feeds are present; links resolve.

### Phase 5 — Content structure and authoring workflow

**Objective:** Make technical publishing repeatable and easy to review.

**Tasks**

- [x] Create content sections for `aws`, `terraform`, `devops`, `security`, and `ai`, with room for `rag` where useful.
- [x] Define front matter, naming, heading, excerpt, image, and publication conventions.
- [x] Add an article template or archetype with safe defaults.
- [x] Document code block languages, command output, warnings, references, and reproducible examples.
- [x] Define image storage, naming, alt text, compression, and attribution rules.
- [x] Choose Mermaid support only if it renders reliably in local and production builds; otherwise use versioned SVG/PNG diagrams.
- [x] Add an editorial checklist covering accuracy, security-sensitive values, links, spelling, accessibility, and mobile rendering.

**Deliverables:** content taxonomy, authoring guide, and archetype. Representative
articles are intentionally deferred until real article content is ready; Phase 5
was scoped to establish the structure and workflow without writing blog articles.

**Dependencies:** Phases 2–4.

**Validation:** a new author can create, preview, validate, and publish an article using the documented workflow. Verified with `hugo new`, draft taxonomy generation, and a final `hugo --minify` build.

**Phase 5 status:** Complete. See [CONTENT_GUIDE.md](CONTENT_GUIDE.md) and
`archetypes/posts.md` for the implemented workflow. The Phase 1–7 readiness
audit above records the current status of later phases.

### Phase 6 — GitHub Actions CI/CD

**Phase 6 status:** Partially complete. Hugo validation and Pages deployment
workflows are implemented, but the Markdown, YAML, and Markdown-aware link
quality gates listed below remain outstanding.

**Objective:** Automate validation and produce a reproducible build artifact.

**Tasks**

- [ ] Add pull-request validation workflow for formatting, Markdown, YAML, links, and Hugo build.
- [ ] Add deployment workflow triggered by pushes to the protected deployment branch.
- [ ] Pin third-party Actions to reviewed major versions or immutable references where practical.
- [ ] Configure least-privilege permissions, including Pages write and artifact write only where required.
- [ ] Cache Hugo modules and dependencies without making the build depend on an unsafe mutable cache.
- [ ] Upload the generated site artifact for the Pages deployment action.
- [ ] Keep secrets out of content, logs, artifacts, and generated HTML.

**Deliverables:** PR validation workflow and deployment workflow.

**Dependencies:** completed Hugo build; GitHub Pages capability.

**Validation:** pull requests fail on invalid content or build errors; a valid change produces a downloadable artifact; workflow permissions are minimal.

### Phase 7 — GitHub Pages deployment

**Phase 7 status:** Partially complete. The deployment workflow and production
`baseURL` are implemented. Repository Pages settings, deployment history, and
public-site smoke checks still require remote GitHub verification.

**Objective:** Publish the validated site reliably.

**Tasks**

- [ ] Configure the repository Pages source as GitHub Actions.
- [ ] Create or use the `github-pages` environment and document protection rules if approvals are desired.
- [ ] Set the correct `baseURL` for project-site or user-site hosting.
- [ ] Configure Pages artifact upload and deployment actions.
- [ ] Add a custom domain only as a later, separately validated change.
- [ ] Confirm HTTPS, redirects, 404 behavior, sitemap, RSS, and canonical links.

**Deliverables:** public GitHub Pages site deployed from the deployment branch.

**Dependencies:** Phases 4 and 6; repository administrator permissions.

**Validation:** a production build is reachable at the expected URL; deployment status is visible in Actions; smoke checks pass.

### Phase 8 — Quality automation and validation

**Phase 8 status:** Complete for the required automation. Markdown, YAML,
workflow syntax, Hugo build, source-document links, and generated-site links
are enforced by the pull-request workflow. Spell checking and scheduled
maintenance checks remain intentionally optional and were not added because
the current technical content would create more noise than value.

**Objective:** Prevent regressions in content, configuration, and generated output.

**Tasks**

- [x] Add Markdown linting with repository-specific rules.
- [x] Add YAML linting for workflows and configuration.
- [ ] Add spell checking with an allowlist for product names, AWS services, and technical terms.
- [x] Add Markdown-aware broken-link checking that understands anchors and local paths.
- [x] Run Hugo build validation with warnings treated as actionable failures where practical.
- [x] Add pre-commit hooks for fast local checks.
- [x] Add a pull-request status summary and retain only non-sensitive diagnostics.
- [ ] Add scheduled link and dependency checks if maintenance value justifies the noise.

**Required automation:** Hugo build, Markdown lint, YAML lint, link checking, and pull-request validation. Implemented in `.github/workflows/validate-pr.yml` and `.github/scripts/validate-quality.sh`.

**Optional automation:** spell check, pre-commit hooks, scheduled checks, Lighthouse/accessibility audits, dependency update bots, and HTML validation.

**Deliverables:** quality gates and documented local equivalents.

**Dependencies:** Phases 5–7.

**Validation:** intentionally broken fixtures fail the relevant checks; valid content passes in a clean environment.

### Phase 9 — Professional portfolio improvements

**Objective:** Turn the blog into a credible engineering portfolio.

**Tasks**

- [ ] Add an About page describing engineering focus and working principles.
- [ ] Add a Projects page with problem, architecture, technology, security, cost, and repository links.
- [ ] Add a Resume/CV page or downloadable PDF when content is ready.
- [ ] Create an AWS architecture showcase with concise diagrams and design decisions.
- [ ] Add GitHub repository integration only if it remains privacy-respecting and low-maintenance.
- [ ] Enable RSS and search as first-class discovery paths.
- [ ] Evaluate comments and newsletter integrations only after defining moderation, privacy, and operational ownership.

**Deliverables:** portfolio pages, project case studies, and showcase content.

**Dependencies:** stable navigation, content workflow, and deployment.

**Validation:** a reviewer can understand the author’s expertise, representative work, and contact or profile paths within a few minutes.

## 3. Repository design plan

### Recommended structure

```text
.
├── .github/workflows/
│   ├── validate.yml
│   └── deploy.yml
├── archetypes/default.md
├── assets/{css,images}/
├── content/
│   ├── _index.md
│   ├── about/_index.md
│   ├── posts/{aws,terraform,devops,security,ai}/
│   ├── projects/_index.md
│   └── resume/_index.md
├── data/
├── layouts/
├── static/{images,favicon}/
├── themes/                 # only when using Git submodules
├── config/_default/
│   ├── hugo.yaml
│   ├── params.yaml
│   ├── menus.yaml
│   └── languages.yaml
├── .editorconfig
├── .gitignore
├── .markdownlint.yml
├── .pre-commit-config.yaml # optional
├── README.md
└── go.mod/go.sum           # only when using Hugo Modules
```

### Version-control strategy

- [ ] Protect `main` (or the selected deployment branch) and require successful PR checks before merge.
- [ ] Use short-lived topic branches for content and configuration changes.
- [ ] Keep commits focused and use pull requests for reviewable changes.
- [ ] Never commit credentials, cloud access keys, private data, generated `public/`, or unoptimized source exports.
- [ ] Tag meaningful site or theme upgrade milestones when useful.

### Asset and theme recommendations

- [ ] Keep reusable source images and diagrams under `assets/` when Hugo processing is needed.
- [ ] Keep directly served files such as favicons, downloadable documents, and stable images under `static/`.
- [ ] Store architecture diagrams as editable source plus optimized rendered output when the source is useful for maintenance.
- [ ] Never edit files inside the Blowfish dependency; use configuration, `layouts/`, `assets/`, and scoped overrides.

## 4. Hugo and Blowfish theme strategy

### Installation comparison

| Criterion           | Hugo Module                                          | Git Submodule                                                |
| ------------------- | ---------------------------------------------------- | ------------------------------------------------------------ |
| Maintainability     | Clean dependency model and good Hugo integration     | Familiar Git model but more manual operations                |
| Upgrade process     | Update the pinned module version and review the diff | Fetch a reviewed commit and update the submodule pointer     |
| Version management  | Explicit in `go.mod`/`go.sum`                        | Explicit in the submodule commit                             |
| Git workflow impact | Requires Go/module tooling and module-aware CI       | Requires recursive checkout and submodule initialization     |
| Long-term fit       | Best when the team accepts Go tooling                | Good fallback for minimal tooling and maximum Git visibility |

**Recommendation:** use a Hugo Module pinned to a known Blowfish release when CI and local tooling can reliably download modules. Use a Git submodule pinned to a reviewed commit if minimizing Go/module dependencies is more important. In either case, document and test upgrades; do not use an unpinned moving branch.

### Blowfish customization checklist

- [ ] Configure site title, description, language, time zone, author details, logo, favicon, and default images.
- [ ] Configure homepage layout and featured content around engineering topics and projects.
- [ ] Configure navigation, footer links, taxonomy pages, breadcrumbs, pagination, and related content.
- [ ] Configure categories for broad topic areas and tags for precise technologies, services, and patterns.
- [ ] Enable dark mode and verify code, tables, diagrams, and images in both themes.
- [ ] Enable search and confirm indexing excludes drafts and private content.
- [ ] Configure SEO title templates, descriptions, canonical URLs, Open Graph images, and structured metadata where supported.
- [ ] Verify RSS feeds, sitemap generation, robots directives, and 404 handling.
- [ ] Keep analytics optional, privacy-aware, and isolated from the core build.
- [ ] Keep custom CSS and layout overrides small, named, and documented.

## 5. Content management workflow

### New article workflow

1. [ ] Create a topic branch.
2. [ ] Generate a post from the archetype with a stable slug and publication date.
3. [ ] Write the article with an explicit problem, context, implementation, trade-offs, security considerations, and conclusion.
4. [ ] Add references and verify all commands, links, diagrams, and code examples.
5. [ ] Preview with drafts enabled and inspect desktop, mobile, dark mode, and accessibility basics.
6. [ ] Run local quality checks and review the rendered output.
7. [ ] Open a pull request; merge only after checks pass and content is reviewed.
8. [ ] Publish by merging to the deployment branch and verify the live page.

### Markdown and front matter standard

Use one consistent front matter format, preferably YAML, with fields such as:

```yaml
title: "Clear technical title"
description: "A concise search and social description."
date: 2026-01-01
draft: true
categories: ["AWS"]
tags: ["Terraform", "Security"]
showAuthor: true
showReadingTime: true
```

- [ ] Use one H1 supplied by the theme; begin article content with H2 headings.
- [ ] Use descriptive slugs and avoid changing published URLs without redirects.
- [ ] Keep categories broad and stable; keep tags specific and reusable.
- [ ] Use fenced code blocks with a language identifier and redact account IDs, secrets, tokens, and private hostnames.
- [ ] Prefer copyable commands with stated prerequisites and expected results.

### Diagrams and images

- [ ] Use Mermaid for simple diagrams only after confirming the chosen rendering path works in GitHub Actions and GitHub Pages.
- [ ] Use versioned SVG or PNG architecture diagrams when exact visual layout and portability matter.
- [ ] Add meaningful alt text and captions; do not use diagrams as the only explanation.
- [ ] Compress raster images, use descriptive filenames, and avoid leaking infrastructure identifiers.
- [ ] Keep images close to the article that owns them unless they are genuinely shared assets.

## 6. GitHub Pages deployment design

### Required workflow

```text
Developer → Git push → Pull Request checks → Merge to deployment branch
         → Hugo production build → Pages artifact upload
         → GitHub Pages deployment → Public site smoke check
```

### Checklist

- [ ] Use a validation workflow on `pull_request` and a deployment workflow on the protected deployment branch.
- [ ] Check out the repository with the required submodules or module dependencies.
- [ ] Install the pinned Hugo Extended version.
- [ ] Run `hugo --minify` with production settings and fail on build errors.
- [ ] Upload only the generated `public/` directory as the Pages artifact.
- [ ] Set workflow permissions to the minimum required, including `contents: read`, `pages: write`, and `id-token: write` only where needed by the deployment action.
- [ ] Declare the Pages environment and deployment URL in the workflow.
- [ ] Use concurrency to prevent stale deployments from racing with newer commits.
- [ ] Confirm the Pages source is GitHub Actions in repository settings.
- [ ] Run post-deployment smoke checks for homepage, one post, CSS, images, RSS, sitemap, and 404 behavior.
- [ ] Document rollback as reverting the source change and redeploying through the normal workflow.

## 7. Quality and automation

### Required

- [ ] Hugo production build validation.
- [ ] Markdown linting.
- [ ] YAML linting for GitHub Actions and configuration.
- [ ] Markdown-aware broken-link checking for local and external links.
- [ ] Pull-request workflow that blocks merge on failed required checks.
- [ ] Secret and sensitive-value scanning appropriate for a public repository.

### Optional

- [ ] Spell checking with a technical vocabulary allowlist.
- [ ] Pre-commit hooks that run fast local checks.
- [ ] Scheduled dependency and external-link checks.
- [ ] Lighthouse or equivalent performance and accessibility audits.
- [ ] HTML validation of the generated site.
- [ ] Automated image optimization.
- [ ] Dependabot or Renovate for Actions, Hugo modules, and tooling.

## 8. Professional blog features

- [ ] About page with technical focus, experience summary, principles, and contact/profile links.
- [ ] Projects page with architecture, role, technologies, security, cost, lessons learned, and repository/demo links.
- [ ] Resume/CV page or downloadable PDF kept current with the site.
- [ ] AWS architecture showcase with diagrams, decision records, and links to relevant articles.
- [ ] Search, taxonomy pages, related posts, RSS, sitemap, and accessible navigation.
- [ ] GitHub repository integration only where it adds clear value without fragile runtime dependencies.
- [ ] Comments only after selecting a low-maintenance provider and defining moderation and privacy rules.
- [ ] Newsletter only after selecting a provider, consent flow, unsubscribe path, and data-retention policy.

## 9. Future enhancement roadmap

- [ ] Add a custom domain after the core site is stable.
- [ ] Add Cloudflare DNS only if DNS, caching, security, or domain-management benefits justify the added dependency.
- [ ] Automate content publishing metadata, previews, and release notes.
- [ ] Evaluate AI-assisted drafting with mandatory human review, citation verification, and secret filtering.
- [ ] Integrate selected GitHub projects with cached build-time data rather than a live client-side dependency.
- [ ] Generate architecture diagram variants from versioned source definitions where the maintenance cost is acceptable.
- [ ] Add optional social-media publishing with explicit approval and platform-specific formatting.

## 10. Engineering acceptance criteria

- [ ] A clean checkout can build the site using documented, pinned tooling.
- [ ] All content and configuration changes are reviewable through Git.
- [ ] Pull requests catch build, formatting, link, and secret issues before merge.
- [ ] Only validated production output is deployed to GitHub Pages.
- [ ] The site is responsive, accessible, searchable, indexable, and usable in dark mode.
- [ ] Core pages and representative technical articles explain the author’s engineering expertise.
- [ ] No credentials, private keys, secrets, or sensitive infrastructure identifiers are present in source, artifacts, logs, or rendered pages.
- [ ] Theme upgrades, content publishing, rollback, and local development are documented.
- [ ] The solution remains low-cost, low-maintenance, and free of unnecessary backend infrastructure.

## Definition of done for the initial release

- [ ] Phases 1–8 are complete.
- [ ] The public site contains Home, About, Posts, Projects, and at least one representative article for each priority topic that is ready to publish.
- [ ] GitHub Actions validation and deployment workflows have passed from a clean pull request and a merged deployment-branch change.
- [ ] GitHub Pages smoke checks pass, including HTTPS, RSS, sitemap, navigation, images, code blocks, and 404 behavior.
- [ ] README and authoring documentation are sufficient for future maintenance without relying on undocumented manual steps.
