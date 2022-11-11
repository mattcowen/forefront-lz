#!/usr/bin/env bash
set -eo pipefail

TFFMT_COUNT=$(terraform fmt -write=false -recursive | wc -l)
if (( $TFFMT_COUNT > 0 )); then
  echo -e "\n*** ERROR! the following files require re-formatting"
  terraform fmt -recursive -check
fi

find . -name .terraform -prune , \
    -type f -name '*.tf' -printf '%h\n' | sort | uniq | \
    xargs -I {} tflint -c ../configuration/.tflint.hcl {} $TF_LINT_ARGS

terraform validate
