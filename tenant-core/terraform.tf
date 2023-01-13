# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0.1"
    }
  }
  backend "azurerm" {
    use_microsoft_graph = true
    use_azuread_auth    = true
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
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


# You can use the azurerm_client_config data resource to dynamically
# extract the current Tenant ID from your connection settings.

# Obtain client configuration from the un-aliased provider
data "azurerm_client_config" "core" {
  provider = azurerm
}


provider "azuread" {
  tenant_id = data.azurerm_client_config.core.tenant_id
}

# Obtain client configuration from the "management" provider
data "azurerm_client_config" "management" {
  provider = azurerm.management
}

# Obtain client configuration from the "connectivity" provider
data "azurerm_client_config" "connectivity" {
  provider = azurerm.connectivity
}


