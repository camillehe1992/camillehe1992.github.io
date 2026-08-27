# Cloud Engineering Portfolio Design

## Goal

Make the Hugo + Blowfish blog communicate a credible Cloud Engineer / DevOps Engineer portfolio while preserving the existing publishing and GitHub Pages deployment model.

## Design

- Keep the current profile homepage and simple Home, Posts, Projects, and About navigation.
- Replace placeholder About and Projects pages with honest, scope-limited content based only on the technical focus areas already supplied.
- Use reusable Markdown conventions for project cards, technology tags, architecture notes, security and cost considerations, and repository links.
- Add a small architecture showcase section using design principles and clearly marked placeholders instead of invented project claims, diagrams, metrics, or repositories.
- Keep GitHub integration manual and privacy-respecting: provide a profile/repository-link pattern without APIs or external dependencies.
- Explicitly defer resume/CV, analytics, custom-domain DNS, comments/newsletter, and AI-assisted publishing until real content or operational ownership exists.

## Validation

Run the existing Hugo production build and quality checks, inspect generated core pages and navigation, and verify that deployment workflow files remain unchanged.
