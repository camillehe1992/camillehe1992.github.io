# Website Maintenance Guide

[中文](WEBSITE_MAINTENANCE_GUIDE.zh.md) ｜ [English](WEBSITE_MAINTENANCE_GUIDE.md)

This is the operational guide for maintaining
`https://camillehe1992.github.io/`, the default GitHub Pages user site. Article
writing and publishing conventions are documented in
[CONTENT_GUIDE.md](CONTENT_GUIDE.md).

## 1. Current site boundaries

Confirmed facts about the technology stack, Hugo Modules integration, Pages
URL, and deployment model are documented in [README.md](../README.md)
(Prerequisites, Configuration notes, Repository conventions) and are not
repeated here.

## 2. Maintenance principles

- Keep Hugo and Blowfish; do not replace the theme or deployment architecture to satisfy a local need.
- Prefer Hugo configuration, content Markdown, and small template overrides to avoid unnecessary dependencies.
- Do not edit Blowfish dependency directories; put theme customization in configuration, `layouts/`, `assets/`, or explicit override files.
- Never commit credentials, private keys, access tokens, account IDs, private hostnames, personal privacy, or sensitive infrastructure information.
- Do not invent projects, architectures, performance metrics, repository links, work history, or personal contact details.
- Every change must be reviewable through Git and remain rollback-safe.
- Verify first, then deploy; only the production-built `public/` may be used as the Pages artifact.

## 3. Repository and branch maintenance

### Day-to-day rules

- Use short-lived branches and Pull Requests for article and configuration changes.
- Keep commits focused; do not mix unrelated formatting, generated files, or dependency upgrades into content changes.
- Do not commit generated directories, temporary files, or local dependencies.
- Theme, Hugo, and CI tooling upgrades should be committed separately with the version changes recorded.
- Create Git tags for important site releases or theme upgrades when needed.

## 4. Hugo and Blowfish maintenance

### Current configuration

- `baseURL` must remain `https://camillehe1992.github.io/`.
- Content language is English and the timezone is `Asia/Shanghai`.
- Main navigation is Home, Posts, Projects, About.
- Search, RSS, sitemap, robots, dark mode, code copy, and accessibility options are enabled.

### Configuration change flow

1. Read the current `config/_default/hugo.yaml`, `params.yaml`, language, and menu configuration first.
2. Change only the settings that satisfy the requirement, and check whether URLs, taxonomies, or output formats would change.
3. Run `hugo --minify --panicOnWarning`.
4. Check the homepage, About, Projects, Posts, RSS, sitemap, robots, and canonical URLs.
5. Document the configuration change and validation results in the Pull Request description.

### Theme upgrade flow

1. Check the current Blowfish version and Hugo compatibility requirements.
2. Update the Hugo Module version and related validation files.
3. Check the impact on navigation, homepage layout, search, SEO, RSS, and dark mode.
4. Complete a local production build and core page checks.
5. Merge and deploy only after the Pull Request is validated.

## 5. Content publishing conventions

Article creation, front matter, technical formatting, visuals, and the
publishing workflow are documented in
[CONTENT_GUIDE.md](CONTENT_GUIDE.md) and are not repeated here.

Maintenance-specific content rules:

- Do not change published URLs casually; design a redirect plan when a change is required.

## 6. GitHub Pages deployment maintenance

### Current deployment model

```text
Developer → Pull Request checks → merge to main
         → Hugo production build → Pages artifact
         → github-pages Environment → public site
```

- Pages Source uses GitHub Actions.
- The `github-pages` Environment is configured.
- Workflows use the minimal `contents`, `pages`, and `id-token` permission scope.
- The Pages artifact uploads only the generated `public/`.
- Workflows use concurrency to prevent old deployments from racing new ones.
- The default URL is `https://camillehe1992.github.io/`.
- HTTPS, redirects, 404, RSS, sitemap, and canonical URLs have been verified.

### Post-publish checks

```sh
curl -I https://camillehe1992.github.io/
curl -I https://camillehe1992.github.io/not-a-real-page/
curl -fsSL https://camillehe1992.github.io/index.xml
curl -fsSL https://camillehe1992.github.io/sitemap.xml
curl -fsSL https://camillehe1992.github.io/ | tr '>' '>\n' | grep -i canonical
```

Confirm that the homepage is reachable, the error page returns 404, RSS and
sitemap return valid content, and canonical URLs use the default user-site URL.

## 7. Quality automation

### Required checks

CI covers or is configured for:

- Hugo production build.
- Markdown lint.
- YAML lint.
- GitHub Actions syntax checks.
- Markdown-aware and generated-site link checks.
- Pull Request validation workflow.
- Non-sensitive PR summary.

Local full checks are documented in the Local publishing workflow section of
[CONTENT_GUIDE.md](CONTENT_GUIDE.md); additionally run `git diff --check`
before committing. Local checks require Node.js 22, `yamllint`, and
`actionlint`; Node.js 18 may not run the currently locked Markdown toolchain.

## 8. Change acceptance criteria

Every important change should at least:

- [ ] Build from a clean checkout with the documented, pinned tools.
- [ ] Pass Git review for all content and configuration changes.
- [ ] Have Pull Requests that catch build, formatting, link, and sensitive-information issues.
- [ ] Deploy only validated production output to GitHub Pages.
- [ ] Keep core pages reachable with working navigation, search, RSS, sitemap, and canonical URLs.
- [ ] Check desktop, mobile, dark mode, and accessibility behavior.
- [ ] Keep source, artifacts, logs, and generated pages free of credentials, private keys, or sensitive infrastructure information.
- [ ] Document theme upgrades, article publishing, rollback, and local development flows.
- [ ] Stay low-cost and low-maintenance without unnecessary backend infrastructure.
