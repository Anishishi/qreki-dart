#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing dependencies"
dart pub get

echo "==> Formatting"
mode="${1:-}"
in_ci=$([[ "$mode" == "ci" ]] && echo true || echo false)

if [[ "$in_ci" == "true" ]]; then
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
shellcheck tool/*.sh
