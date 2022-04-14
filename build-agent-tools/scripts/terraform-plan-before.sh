#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo -e "\e[31m»»» 💥 Pass plan name as parameter to this script e.g. $0 foo"
  exit 1
fi

#check for env file in root of project
if [ ! -f "../.env" ]; then
  echo -e "\e[31m»»» ⚠️ .env file not found in root, I do hope those ARM_ variables are set!"

  printenv

else
  # Load environmental vars from .env file
  echo -e "\n\e[34m»»» 🧩 \e[96mLoading environmental variables\e[0m..."
  cat "../.env"|grep =|grep -v SECRET
  echo ""
  export $(egrep -v '^#' "../.env" | xargs)
fi



TFPLAN_NAME=${1}

terraform plan -input=false -out ${TFPLAN_NAME}.tfplan

# terraform show -json ${TFPLAN_NAME}.tfplan
