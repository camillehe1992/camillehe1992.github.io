#!/usr/bin/env bash
set -euo pipefail

run_step() {
  local name="$1"
  shift
  echo "::group::$name"
  "$@"
  echo "::endgroup::"
}

run_step "Markdown lint" npm run lint:markdown
run_step "YAML lint" yamllint -c .yamllint .github config
run_step "GitHub Actions syntax" actionlint
run_step "Hugo build" hugo --minify --panicOnWarning
run_step "Generated-site links" npm exec --no -- linkinator public --recurse --check-fragments --skip "camillehe1992\.github\.io" --skip "linkedin\.com" --silent
