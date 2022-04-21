# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "< 3.0.0"
    }
  }
  backend "azurerm" {
    use_microsoft_graph = true
    use_azuread_auth    = true
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = var.connectivity_subid
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = var.management_subid
  features {}
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = var.identity_subid
  features {}
}

# You can use the azurerm_client_config data resource to dynamically
# extract the current Tenant ID from your connection settings.

# Obtain client configuration from the un-aliased provider
data "azurerm_client_config" "core" {
  provider = azurerm
}

# Obtain client configuration from the "management" provider
data "azurerm_client_config" "management" {
  provider = azurerm.management
}

# Obtain client configuration from the "connectivity" provider
data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}

data "azurerm_client_config" "identity" {
  provider = azurerm.identity
}
