#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Change as required
REGION=uksouth

echo -e "\n\e[34m╔══════════════════════════════════╗"
echo -e "║\e[33m        Pre Bootstrap! 🥾\e[34m         ║"
echo -e "║\e[32m    Deploy Management Infra 🚀\e[34m    ║"
echo -e "╚══════════════════════════════════╝"

echo -e "\n\e[34m»»» ✅ \e[96mChecking pre-reqs\e[0m..."

# Load env vars from .env file
if [ ! -f "$DIR/.env" ]; then
  echo -e "\e[31m»»» 💥  Unable to find .env file, please create file and try again!"
  exit
else
  echo -e "\n\e[34m»»» 🧩 \e[96mLoading environmental variables\e[0m..."
  export $(egrep -v '^#' "$DIR/.env" | xargs)
fi

az > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\e[31m»»» ⚠️  Azure CLI is not installed! 😥 Please go to http://aka.ms/cli to set it up"
  exit
fi

terraform version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\e[31m»»» ⚠️  Terraform is not installed! 😥 Please go to https://www.terraform.io/downloads.html to set it up"
  exit
fi

SUB_NAME=$(az account show --query name -o tsv)
SUB_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)
if [ -z "$SUB_NAME" ]; then
  echo -e "\n\e[31m»»» ⚠️  You are not logged in to Azure!"
  exit
fi

echo -e "\e[34m»»» 🔨 \e[96mAzure details from logged on user \e[0m"
echo -e "\e[34m»»»   • \e[96mSubscription: \e[33m$SUB_NAME\e[0m"
echo -e "\e[34m»»»   • \e[96mTenant:       \e[33m$TENANT_ID\e[0m\n"

read -p " - Are these details correct, do you want to continue (y/n)? " answer
case ${answer:0:1} in
    y|Y )
    ;;
    * )
        echo -e "\e[31m»»» 😲 Deployment canceled\e[0m\n"
        exit
    ;;
esac

# Baseline Azure resources
echo -e "\n\e[34m»»» 🤖 \e[96mCreating resource group and storage account\e[0m..."
az group create --resource-group $BACKEND_RESGRP --location $REGION -o table
az storage account create --resource-group $BACKEND_RESGRP \
--name $BACKEND_STORAGE_ACCOUNT --location $REGION \
--kind BlobStorage --sku Standard_RAGRS --access-tier Hot -o table

# Blob container
SA_KEY=$(az storage account keys list --account-name $BACKEND_STORAGE_ACCOUNT --query "[0].value" -o tsv)
az storage container create --account-name $BACKEND_STORAGE_ACCOUNT --name $BACKEND_CONTAINER --account-key $SA_KEY -o table

# Set up Terraform
echo -e "\n\e[34m»»» ✨ \e[96mTerraform init\e[0m..."
terraform init \
  -backend-config="resource_group_name=$BACKEND_RESGRP" \
  -backend-config="storage_account_name=$BACKEND_STORAGE_ACCOUNT" \
  -backend-config="container_name=$BACKEND_CONTAINER" 

# Import the storage account & res group
echo -e "\n\e[34m»»» 📤 \e[96mImporting resources to state\e[0m..."
terraform import azurerm_resource_group.mgmt "/subscriptions/$SUB_ID/resourceGroups/$BACKEND_RESGRP"
terraform import azurerm_storage_account.tf_state_sa "/subscriptions/$SUB_ID/resourceGroups/$BACKEND_RESGRP/providers/Microsoft.Storage/storageAccounts/$BACKEND_STORAGE_ACCOUNT"