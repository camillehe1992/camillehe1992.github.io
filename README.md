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

Phase 1 — project initialization and repository structure.

The implementation roadmap is maintained in [BLOG_IMPLEMENTATION_CHECKLIST.md](BLOG_IMPLEMENTATION_CHECKLIST.md). Later phases will add Hugo, the Blowfish theme, content, quality automation, and GitHub Pages deployment.

## Planned repository conventions

- Source content and configuration are reviewed and versioned through Git.
- Generated Hugo output is not committed to the source branch.
- Pull requests will be used for content and configuration changes.
- Production deployment will be performed by GitHub Actions after the site build and quality checks pass.
- Secrets, credentials, private keys, and sensitive infrastructure identifiers must never be committed.

## Prerequisites

The initial setup does not install or pin Hugo yet. Phase 2 will select and document the Hugo Extended version after the Blowfish compatibility target is confirmed.

Planned local tooling:

- Git
- Hugo Extended
- GitHub CLI, optional

## Planned local workflow

Once Hugo is initialized in Phase 2, the expected local workflow will be:

```sh
hugo server --buildDrafts
hugo --minify
```

These commands are documented as the target workflow only; they are not expected to work until Hugo setup is completed.

## License and content ownership

Add the project license and content reuse policy before the first public release. Technical articles must identify third-party material and preserve applicable licenses.
