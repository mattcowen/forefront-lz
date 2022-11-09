#!/usr/bin/env bash

set -euo pipefail

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


#terraform import azurerm_virtual_network_gateway.connectivity "/subscriptions/01fb43ea-bea4-46fb-8939-fc958fc989e9/resourceGroups/forefrdev-connectivity-uksouth/providers/Microsoft.Network/virtualNetworkGateways/forefrdev-vpngw-uksouth"


terraform import azurerm_local_network_gateway.localvnetgw "/subscriptions/01fb43ea-bea4-46fb-8939-fc958fc989e9/resourceGroups/forefrdev-connectivity-uksouth/providers/Microsoft.Network/localNetworkGateways/Office"
terraform import azurerm_virtual_network_gateway_connection.vnetgwconn  "/subscriptions/01fb43ea-bea4-46fb-8939-fc958fc989e9/resourceGroups/forefrdev-connectivity-uksouth/providers/Microsoft.Network/connections/Office"

