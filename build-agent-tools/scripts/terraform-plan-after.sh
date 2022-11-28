#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo -e "\e[31m»»» 💥 Pass plan name as parameter to this script e.g. $0 foo"
  exit 1
fi

if [ ! -f "./.env" ]; then
  echo -e "\e[31m»»» ⚠️ .env file not found, I do hope those ARM_ variables are set!"
else
  # Load environmental vars from .env file
  echo -e "\n\e[34m»»» 🧩 \e[96mLoading environmental variables\e[0m..."
  cat "./.env"|grep =|grep -v SECRET
  echo ""
  export $(egrep -v '^#' "./.env" | xargs)
fi

TFPLAN_NAME=${1}

terraform plan -input=false -out ${TFPLAN_NAME}.tfplan

terraform show -json ${TFPLAN_NAME}.tfplan > tfShow.json

#cat tfShow.json

cat tfShow.json | jq -r .resource_changes[] > changesArray.json

#cat changesArray.json 

#cat changesArray.json | jq -r .change.actions[] > actionsArray.txt
# the following select is necessary because the DiagnosticsInitiative gets flagged by TF as needing a change
# so we ignore the policy definitions in "basic_set" that cause the issue.
cat changesArray.json | jq 'select( .address != "module.initatives.module.diagnostic_policies.azurerm_policy_set_definition.basic_set")' | jq -r .change.actions[] > actionsArray.txt

# add something bad to the actions array to force failure
# echo "delete" >> actionsArray.txt

#cat actionsArray.txt
echo "-----------"
echo ""
echo "Testing the actions for each resource to ensure all are no-op."
for action in `cat actionsArray.txt`; do
  
  if [ $action != 'no-op' ]; then
    echo 'TF plan after apply is not clean: ' $action
    exit 1
  fi

done
