#!/usr/bin/env bash
set -euo pipefail

echo '*** Terraform version'
terraform --version

echo -e '\n*** Azure CLI version'
az --version

echo -e '\n*** jq version'
jq --version

echo -e '\n*** Go version'
go version

echo -e '\n*** gotestsum version'
gotestsum --version

echo -e '\n*** golangci-lint version'
golangci-lint --version
