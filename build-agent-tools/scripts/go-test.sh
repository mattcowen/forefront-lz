#!/usr/bin/env bash
set -euo pipefail

#
# Run Go unit tests via gotestsum wrapper, output results in JUnit XML format
#
# Script is intended to be run in CI pipeline
#

# Important othewise cached tests results in nothing being run
export GODEBUG=gocacheverify=1

# Note without the verbose flag it's impossible to see what terratest is doing
gotestsum --junitfile test-results.xml --format standard-verbose -- -timeout=30m -parallel 10
