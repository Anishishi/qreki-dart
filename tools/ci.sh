#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing dependencies"
dart pub get

echo "==> Formatting"
mode="${1:-}"
if [[ "$mode" == "ci" || "${CI:-}" == "true" ]]; then
  dart format --output=none --set-exit-if-changed .
else
  dart format .
fi

echo "==> Analyzing"
dart analyze

echo "==> Testing"
dart test

echo "==> Publish dry run"
dart pub publish --dry-run

echo "==> Shell lint"
shellcheck tools/*.sh
