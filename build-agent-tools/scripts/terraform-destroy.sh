#!/usr/bin/env bash
set -euo pipefail

if [ ! -f "../.env" ]; then
  echo -e "\e[31m»»» ⚠️ .env file not found, I do hope those ARM_ variables are set!"
else
  # Load environmental vars from .env file
  echo -e "\n\e[34m»»» 🧩 \e[96mLoading environmental variables\e[0m..."
  cat "../.env"|grep =|grep -v SECRET
  echo ""
  export $(egrep -v '^#' "../.env" | xargs)
fi

terraform destroy -auto-approve
