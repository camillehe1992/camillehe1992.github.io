# Personal Technical Blog

Professional personal technical blog built with Hugo and the Blowfish theme, published through GitHub Pages.

The blog is intended to document practical engineering work and serve as a long-term portfolio covering:

- AWS Cloud Architecture
- Terraform and CloudFormation
- DevOps and CI/CD
- GitHub Actions
- Cloud Security
- AI Engineering and RAG applications

## Project status

Phase 1–3 and Phase 5 are complete. Phase 4, Phase 6, and Phase 7 remain
partially complete pending the readiness audit in
[BLOG_IMPLEMENTATION_CHECKLIST.md](BLOG_IMPLEMENTATION_CHECKLIST.md).

The implementation roadmap and the Phase 1–7 pre-Phase-8 audit are maintained
in [BLOG_IMPLEMENTATION_CHECKLIST.md](BLOG_IMPLEMENTATION_CHECKLIST.md).

## Planned repository conventions

- Source content and configuration are reviewed and versioned through Git.
- Generated Hugo output is not committed to the source branch.
- Pull requests will be used for content and configuration changes.
- Production deployment is performed by GitHub Actions after the site build;
  the remaining quality gates are tracked in the checklist.
- Secrets, credentials, private keys, and sensitive infrastructure identifiers must never be committed.

## Prerequisites

The repository uses Hugo Extended. The currently validated version is `0.165.0`, recorded in `.hugo-version`. This satisfies the current Blowfish v3 minimum requirement of Hugo `0.162.0`. Blowfish integration remains a separate Phase 3 task.

Planned local tooling:

- Git
- Hugo Extended `0.165.0` (see `.hugo-version`)
- Go 1.21 or newer for Hugo Modules
- Node.js 22 or newer for Markdown and generated-site checks
- GitHub CLI, optional

## Local validation workflow

The local Hugo workflow is documented in [CONTENT_GUIDE.md](CONTENT_GUIDE.md). The short version is:

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

The development server includes draft content for local review. Production builds exclude drafts by default and write generated output to `public/`, which remains untracked.

## Configuration notes

- `config/_default/hugo.yaml`, `params.yaml`, `languages.en.yaml`, and `menus.en.yaml` contain site and Blowfish configuration.
- `baseURL` is configured for the GitHub Pages user site at
  `https://camillehe1992.github.io/`.
- Technical posts are organized under `content/posts/{aws,terraform,cloudformation,devops,security,ai}/`; see [CONTENT_GUIDE.md](CONTENT_GUIDE.md) for front matter, visuals, formatting, and editorial review conventions.
- Blowfish v3.4.0 is imported through `config/_default/module.toml` and pinned in `go.mod`/`go.sum`.
- Social profile links remain unconfigured until real profile URLs are available; analytics, comments, and deployment settings are intentionally out of scope.

CI runs the same Markdown, YAML, Hugo, and generated-site link gates on pull
requests. Install Node.js 22, `yamllint`, and `actionlint` locally for exact
parity; pre-commit intentionally runs only the fast Markdown and YAML checks.

## License and content ownership

Add the project license and content reuse policy before the first public release. Technical articles must identify third-party material and preserve applicable licenses.
