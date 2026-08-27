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

Phase 2 — Hugo core setup.

The implementation roadmap is maintained in [BLOG_IMPLEMENTATION_CHECKLIST.md](BLOG_IMPLEMENTATION_CHECKLIST.md). Later phases will add the Blowfish theme, site customization, quality automation, and GitHub Pages deployment.

## Planned repository conventions

- Source content and configuration are reviewed and versioned through Git.
- Generated Hugo output is not committed to the source branch.
- Pull requests will be used for content and configuration changes.
- Production deployment will be performed by GitHub Actions after the site build and quality checks pass.
- Secrets, credentials, private keys, and sensitive infrastructure identifiers must never be committed.

## Prerequisites

The repository uses Hugo Extended. The currently validated local version is `0.119.0`; the exact CI toolchain will be pinned when the deployment workflow is added. Blowfish integration and compatibility verification are intentionally deferred to Phase 3.

Planned local tooling:

- Git
- Hugo Extended
- GitHub CLI, optional

## Planned local workflow

The local Hugo workflow is:

```sh
hugo server --buildDrafts
hugo --minify
```

The development server includes draft content for local review. Production builds exclude drafts by default and write generated output to `public/`, which remains untracked.

## Configuration notes

- `config/_default/hugo.yaml` contains the core site configuration and is deliberately theme-neutral.
- `baseURL` is a placeholder until the GitHub repository URL is finalized; update it before deployment.
- The `content/` files are minimal structural validation content. The representative post is a draft and is not intended for publication.

## License and content ownership

Add the project license and content reuse policy before the first public release. Technical articles must identify third-party material and preserve applicable licenses.
