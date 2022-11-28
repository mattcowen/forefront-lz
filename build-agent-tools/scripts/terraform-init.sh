#!/usr/bin/env bash
set -euox pipefail

# Pretty banner
echo -e "\n\e[34m╔══════════════════════════════════╗"
echo -e "║\e[32m        Terraform Backend \e[34m        ║"
echo -e "║\e[33m        Initialize Script  \e[34m       ║"
echo -e "╚══════════════════════════════════╝"
echo -e "\e[35m   v0.0.1    🚀  🚀  🚀\n"

echo -e "\n\e[34m»»» ✅ \e[96mChecking pre-reqs\e[0m..."
az > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\e[31m»»» ⚠️ Azure CLI is not installed! 😥 Please go to http://aka.ms/cli to set it up"
  exit
fi

terraform version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\e[31m»»» ⚠️ Terraform is not installed! 😥 Please go to https://www.terraform.io/downloads.html to set it up"
  exit
fi

if [ ! -f "./.env" ]; then
  echo -e "\e[31m»»» ⚠️ .env file not found, I do hope those BACKEND_ variables are set!"
else
  # Load environmental vars from .env file
  echo -e "\n\e[34m»»» 🧩 \e[96mLoading environmental variables\e[0m..."
  cat "./.env"|grep =|grep -v SECRET
  echo ""  
  export $(egrep -v '^#' "./.env" | xargs)
fi

echo -e "\n\e[34m»»» ✨ \e[96mTerraform init\e[0m..."
terraform init -input=false -reconfigure \
  -backend-config="resource_group_name=$BACKEND_RESGRP" \
  -backend-config="storage_account_name=$BACKEND_STORAGE_ACCOUNT" \
  -backend-config="container_name=$BACKEND_CONTAINER" \
  -backend-config="client_id=$BACKEND_CLIENT_ID" \
  -backend-config="client_secret=$BACKEND_CLIENT_SECRET" \
  -backend-config="subscription_id=$BACKEND_CLIENT_SUBSCRIPTION_ID" \
  -backend-config="tenant_id=$BACKEND_CLIENT_TENANTID" \
  -backend-config="key=$BACKEND_KEY.tfstate"

if [[ $# -lt 1 ]]; then
  echo -e "\e[31m»»» 💥 End of init"
fi