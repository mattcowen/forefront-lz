#!/usr/bin/env bash
set -euo pipefail

#
# Go fmt, vet and linting script
#
# Script is intended to be run in CI pipeline, error & exit on problems rather than fix them
#

# Run 'gofmt' to check code format - https://golang.org/cmd/gofmt/
GOFMT_COUNT=$(gofmt -l . | wc -l)
if (( $GOFMT_COUNT > 0)); then
  # Print diff of what gofmt would have changed
  gofmt -d .
  echo -e "\n*** ERROR! gofmt found one or more files requiring re-formatting";
  exit 1
fi

# Run 'go vet' to check for code problems - https://golang.org/cmd/vet/
go vet

# Run golangci-lint, TODO: Move enabled linters and other config to external conf file
# See https://golangci-lint.run/usage/configuration/ & https://golangci-lint.run/usage/linters/
golangci-lint run --tests --out-format tab -E "whitespace"