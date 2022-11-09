# Contributor role definition as a data Source
data "azurerm_role_definition" "contributor" {
  name = var.contributor_role_name
}

# Owner role definition as a data Source
data "azurerm_role_definition" "owner" {
  name = var.owner_role_name
}

# Reader role definition as a data Source
data "azurerm_role_definition" "reader" {
  name = var.reader_role_name
}

# Subscription owner as a data source
data "azuread_user" "connectivity_owner" {
  user_principal_name = var.connectivity_subscription_owner
}
data "azuread_user" "identity_owner" {
  user_principal_name = var.identity_subscription_owner
}
data "azuread_user" "management_owner" {
  user_principal_name = var.management_subscription_owner
}