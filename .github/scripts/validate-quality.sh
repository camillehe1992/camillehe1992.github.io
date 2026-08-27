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
run_step "Generated-site links" bash -c '
  python3 -m http.server 4173 --directory public >/tmp/hugo-link-check.log 2>&1 &
  server_pid=$!
  trap "kill $server_pid" EXIT
  sleep 1
  npm exec --no -- linkinator http://127.0.0.1:4173 --recurse --check-fragments --silent
'
