provider "azurerm" {
  features {}
}

#
# Core management resources
#

resource "azurerm_resource_group" "mgmt" {
  name     = var.resource_group_name
  location = var.resource_region
}

# Holds Terraform shared state
resource "azurerm_storage_account" "tf_state_sa" {
  name                     = var.state_sa_name
  resource_group_name      = azurerm_resource_group.mgmt.name
  location                 = azurerm_resource_group.mgmt.location
  account_tier             = "Standard"
  account_kind             = "BlobStorage"
  account_replication_type = "RAGRS"
  allow_blob_public_access = false
}

# Holds agent tools image 
resource "azurerm_container_registry" "shared_acr" {
  name                = var.shared_acr_name
  resource_group_name = azurerm_resource_group.mgmt.name
  location            = azurerm_resource_group.mgmt.location
  sku                 = "Standard"
  admin_enabled       = false
}

#
# KeyVault & service principal to access it
#

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "shared_kv" {
  name                       = var.shared_keyvault_name
  location                   = azurerm_resource_group.mgmt.location
  resource_group_name        = azurerm_resource_group.mgmt.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled        = true
  soft_delete_retention_days = 30

  sku_name = "standard"
}

resource "azuread_application" "sc_keyvault_app" {
  display_name = var.sc_keyvault_sp_name
}

resource "azuread_service_principal" "sc_keyvault_sp" {
  application_id = azuread_application.sc_keyvault_app.application_id
}

# resource "random_password" "password" {
#   length      = 16
#   special     = true
#   min_numeric = 1
#   min_special = 1
#   min_lower   = 1
#   min_upper   = 1
# }

resource "azuread_application_password" "sc_keyvault_sp_password" {
  application_object_id = azuread_application.sc_keyvault_app.id
  #value                 = random_password.password.result
  end_date              = "2040-01-01T00:00:00Z"
  #description           = "TF generated password"
}

resource "azurerm_key_vault_access_policy" "sc_keyvault_access_policy" {
  key_vault_id = azurerm_key_vault.shared_kv.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azuread_service_principal.sc_keyvault_sp.id
  #azuread_application.sc_keyvault_app.object_id

  secret_permissions = [
    "get", "list"
  ]
}

resource "azurerm_role_assignment" "rg_reader" {
  scope                            = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name             = "Key Vault Reader"
  principal_id                     = azuread_service_principal.sc_keyvault_sp.id
  skip_service_principal_aad_check = true
}
