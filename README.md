# Personal Technical Blog

[中文](README.zh.md) ｜ [English](README.md)

Professional personal technical blog built with Hugo and the Blowfish theme, published through GitHub Pages.

The live site is the default GitHub Pages user site: <https://camillehe1992.github.io/>.

The blog is intended to document practical engineering work and serve as a long-term portfolio covering:

- Public Cloud Architecture (AWS)
- Infrastructure as Code (Terraform, CloudFormation)
- DevOps, CI/CD, and GitHub Actions
- Cloud Security
- AI Engineering and RAG Applications

## Prerequisites

The repository uses Hugo Extended `0.165.0`, recorded in `.hugo-version`. This
is compatible with the current Blowfish v3 integration.

Local tooling:

- Git
- Hugo Extended `0.165.0` (see `.hugo-version`)
- Go 1.21 or newer for Hugo Modules
- Node.js 22 or newer for Markdown and generated-site checks

## Local workflow

The article creation and publishing workflow is documented in the
[content guide](docs/CONTENT_GUIDE.md), which covers article structure, front
matter, visuals, technical formatting, editorial review, and publishing
conventions.

The development server includes draft content for local review
(`hugo server --buildDrafts`). Production builds exclude drafts by default and
write generated output to `public/`, which remains untracked.

## Configuration notes

- `config/_default/hugo.yaml`, `params.yaml`, `languages.en.yaml`, and `menus.en.yaml` contain site and Blowfish configuration.
- `baseURL` is configured for the GitHub Pages user site at
  `https://camillehe1992.github.io/`.
- Technical posts are organized under `content/posts/{aws,terraform,cloudformation,devops,security,ai}/`; see [docs/CONTENT_GUIDE.md](docs/CONTENT_GUIDE.md) for front matter, visuals, formatting, and editorial review conventions.
- Blowfish v3.4.0 is imported through `config/_default/module.toml` and pinned in `go.mod`/`go.sum`.
- GitHub, LinkedIn, and email profile links are configured in
  `config/_default/languages.en.yaml`.
- Analytics, comments, Newsletter, Resume/CV, and AI-assisted publishing are
  out of scope for the current site.

CI runs Markdown, YAML, GitHub Actions syntax, Hugo, and generated-site link
gates on pull requests. Install Node.js 22, `yamllint`, and `actionlint` locally
for exact parity. Pre-commit hooks are configured in `.pre-commit-config.yaml`
as optional local fast checks; spell checking, secret scanning, scheduled
checks, and Lighthouse audits are not part of the current quality gates.

## Repository conventions

- Source content and configuration are reviewed and versioned through Git.
- Generated Hugo output is not committed to the source branch.
- Pull Requests are used for content and configuration changes.
- GitHub Actions builds and deploys the validated Pages artifact.
- Secrets, credentials, private keys, and sensitive infrastructure identifiers
  must never be committed.

## Documentation

- [Content guide](docs/CONTENT_GUIDE.md) ｜ [中文](docs/CONTENT_GUIDE.zh.md):
  article creation, editing, and publishing conventions.
- [Website maintenance guide](docs/WEBSITE_MAINTENANCE_GUIDE.md) ｜
  [中文](docs/WEBSITE_MAINTENANCE_GUIDE.zh.md): configuration, deployment,
  and quality gates.

## License and content ownership

Add the project license and content reuse policy before treating the site as a
fully documented public portfolio. Technical articles must identify
third-party material and preserve applicable licenses.
