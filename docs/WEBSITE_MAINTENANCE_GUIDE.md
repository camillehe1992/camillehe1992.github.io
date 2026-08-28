# Website Maintenance Guide

[中文](WEBSITE_MAINTENANCE_GUIDE.zh.md) ｜ [English](WEBSITE_MAINTENANCE_GUIDE.md)

This is the operational guide for maintaining
`https://camillehe1992.github.io/`, the default GitHub Pages user site. Article
writing and publishing conventions are documented in
[CONTENT_GUIDE.md](CONTENT_GUIDE.md).

This guide distinguishes three states:

- **Complete:** supported by current repository or public-site evidence.
- **Outstanding:** not implemented yet.
- **Unverified:** requires repository access, live environment access, or broader device testing.

## 1. Current site boundaries

Confirmed facts about the technology stack, Hugo Modules integration, Pages
URL, and deployment model are documented in [README.md](../README.md)
(Prerequisites, Configuration notes, Repository conventions) and are not
repeated here.

### Unverified or out of scope

- Custom domains, DNS, and CNAME configuration are out of scope for the current project.
- GitHub repository branch protection rules and required checks are not yet recorded in repository settings.
- The full GitHub Actions deployment history is not part of the local repository evidence.
- Mobile breakpoints, real-device behavior, and Lighthouse scores have not been systematically verified.
- Social account URLs, avatars, location, and public contact details are not provided and must not be added speculatively.
- Analytics, comments, Newsletter, and complex AI-assisted publishing flows are not enabled.

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

### Outstanding or unconfirmed

- [ ] Protect `main` in the GitHub repository and require Pull Requests to pass required checks before merging.
- [ ] Record the actual required-checks names in repository documentation.
- [ ] Confirm that the default branch, branch protection, and Actions permission settings match the current workflows.

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

### Outstanding or unconfirmed

- [ ] Add a real avatar, logo, default social image, and public profile links.
- [ ] Verify code, tables, images, and future charts in both dark and light mode.
- [ ] Complete real checks on mobile devices and responsive breakpoints.
- [ ] Confirm that search does not index drafts or private content.
- [ ] Maintain a dedicated check for SEO title templates, Open Graph images, and structured data.
- [ ] Document the naming, scope, and maintenance of custom CSS and layout overrides.

## 5. Content publishing conventions

Article creation, front matter, technical formatting, visuals, publishing
workflow, and current content status are documented in
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

Currently confirmed:

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

### Outstanding or unconfirmed

- [ ] Record the most recent successful Actions deployment run ID and deployment time.
- [ ] Record whether `github-pages` Environment protection requires reviewers.
- [ ] Complete post-publish checks on a real mobile device.
- [ ] Add rollback runbooks: revert source changes and redeploy through the normal workflow.

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

### Outstanding or unconfirmed

- [ ] Add spell checking with an AWS/technical-terms allowlist.
- [ ] Add formal pre-commit hooks; currently planned only as optional fast checks.
- [ ] Add scheduled external-link and dependency checks.
- [ ] Add Lighthouse or equivalent performance/accessibility audits.
- [ ] Add generated-HTML validation.
- [ ] Add automated image optimization.
- [ ] Evaluate Dependabot or Renovate.
- [ ] Add secret/sensitive-value scanning suitable for a public repository.

## 8. Feature maintenance status

### Complete or available

- About, Projects, and Posts pages plus core navigation.

### Outstanding or deferred

- [ ] Resume/CV page or downloadable PDF.
- [ ] Real project case studies with architecture diagrams, role descriptions, outcomes, and repository/demo links.
- [ ] Real profile/contact links.
- [ ] Comment system with moderation and privacy rules.
- [ ] Newsletter provider, consent, unsubscribe, and data retention policies.
- [ ] Analytics, which requires a privacy policy and an accountable owner first.

## 9. Future feature planning

Prioritized by low risk and low maintenance:

1. Publish real technical articles and project case studies with public repository links.
2. Add a Resume/CV page once content is ready.
3. Complete mobile, Lighthouse, HTML, and accessibility audits.
4. Choose spell, dependency, external-link, and image automation based on maintenance value.
5. Evaluate build-time GitHub project data to avoid client-side live API dependencies.
6. Evaluate AI-assisted drafts, citation checks, architecture-diagram generation, and publish summaries only when a real need exists; keep human review, citation validation, and secret filtering.
7. Evaluate Analytics, comments, Newsletter, or social media publishing only when clearly needed.
8. Custom domains, Cloudflare DNS, caching, and security services are not part of the current default URL plan; if hosting strategy changes, open a separate change and re-verify HTTPS, canonical URLs, and DNS.

## 10. Change acceptance criteria

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

## 11. Summary of outstanding work

Do not mark the following as complete until the conditions are met:

- Recorded GitHub repository branch protection and required-checks settings.
- Maintained records of Actions deployment history and `github-pages` Environment protection rules.
- Real avatar, social links, profile/contact links, and public resume information.
- Resume/CV page or PDF.
- Real project case studies, architecture diagrams, metrics, and repository links.
- Dated technical articles, especially representative articles ready for public release.
- Mobile real-device, Lighthouse, HTML, and accessibility verification.
- Spell checking, secret scanning, pre-commit, scheduled dependency/external-link checks, and image optimization.
- Privacy and operations plans for comments, Newsletter, Analytics, and AI-assisted publishing.
- Custom domains, DNS, and CNAME, which the current default user site does not require.
