data "azurerm_subscription" "connectivitysub" {
  subscription_id = var.connectivity_subid
}
data "azurerm_subscription" "identitysub" {
  subscription_id = var.identity_subid
}
data "azurerm_subscription" "managementsub" {
  subscription_id = var.management_subid
}

# security group creation for platform subscriptions

resource "azuread_group" "connectivity_owners_group" {
  display_name = "${data.azurerm_subscription.connectivitysub.display_name} Owners"
  members = [
    data.azuread_user.connectivity_owner.id,
    data.azurerm_client_config.connectivity.object_id
  ]
  security_enabled = true
}
resource "azuread_group" "connectivity_contributors_group" {
  display_name = "${data.azurerm_subscription.connectivitysub.display_name} Contributors"
  members = [
    data.azuread_user.connectivity_owner.id,
    data.azurerm_client_config.connectivity.object_id
  ]
  owners = [
    data.azuread_user.connectivity_owner.id
  ]
  security_enabled = true
}
resource "azuread_group" "connectivity_readers_group" {
  display_name = "${data.azurerm_subscription.connectivitysub.display_name} Readers"
  members = [
    data.azuread_user.connectivity_owner.id,
  ]
  owners = [
    data.azuread_user.connectivity_owner.id
  ]
  security_enabled = true
}


resource "azuread_group" "identity_owners_group" {
  display_name = "${data.azurerm_subscription.identitysub.display_name} Owners"
  members = [
    data.azuread_user.identity_owner.id,
    data.azurerm_client_config.identity.object_id
  ]
  security_enabled = true
}
resource "azuread_group" "identity_contributors_group" {
  display_name = "${data.azurerm_subscription.identitysub.display_name} Contributors"
  members = [
    data.azuread_user.identity_owner.id,
  ]
  owners = [
    data.azuread_user.identity_owner.id
  ]
  security_enabled = true
}
resource "azuread_group" "identity_readers_group" {
  display_name = "${data.azurerm_subscription.identitysub.display_name} Readers"
  members = [
    data.azuread_user.identity_owner.id,
    data.azurerm_client_config.identity.object_id
  ]
  owners = [
    data.azuread_user.identity_owner.id
  ]
  security_enabled = true
}



resource "azuread_group" "management_owners_group" {
  display_name = "${data.azurerm_subscription.managementsub.display_name} Owners"
  members = [
    data.azuread_user.management_owner.id,
    data.azurerm_client_config.management.object_id
  ]
  security_enabled = true
}
resource "azuread_group" "management_contributors_group" {
  display_name = "${data.azurerm_subscription.managementsub.display_name} Contributors"
  members = [
    data.azuread_user.management_owner.id,
    data.azurerm_client_config.connectivity.object_id
  ]
  owners = [
    data.azuread_user.management_owner.id
  ]
  security_enabled = true
}
resource "azuread_group" "management_readers_group" {
  display_name = "${data.azurerm_subscription.managementsub.display_name} Readers"
  members = [
    data.azuread_user.management_owner.id,
    data.azurerm_client_config.management.object_id
  ]
  owners = [
    data.azuread_user.management_owner.id
  ]
  security_enabled = true
}


# role assignments to platform subscription security groups

resource "azurerm_role_assignment" "connectivity_contributor_ra" {
  provider           = azurerm.connectivity
  scope              = "/subscriptions/${var.connectivity_subid}"
  role_definition_id = "${data.azurerm_subscription.connectivitysub.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.connectivity_contributors_group.id
}
resource "azurerm_role_assignment" "connectivity_owner_ra" {
  provider           = azurerm.connectivity
  scope              = "/subscriptions/${var.connectivity_subid}"
  role_definition_id = "${data.azurerm_subscription.connectivitysub.id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.connectivity_owners_group.id
}
resource "azurerm_role_assignment" "connectivity_reader_ra" {
  provider           = azurerm.connectivity
  scope              = "/subscriptions/${var.connectivity_subid}"
  role_definition_id = "${data.azurerm_subscription.connectivitysub.id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.connectivity_readers_group.id
}


resource "azurerm_role_assignment" "identity_contributor_ra" {
  provider           = azurerm.identity
  scope              = "/subscriptions/${var.identity_subid}"
  role_definition_id = "${data.azurerm_subscription.identitysub.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.identity_contributors_group.id
}
resource "azurerm_role_assignment" "identity_owner_ra" {
  provider           = azurerm.identity
  scope              = "/subscriptions/${var.identity_subid}"
  role_definition_id = "${data.azurerm_subscription.identitysub.id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.identity_owners_group.id
}
resource "azurerm_role_assignment" "identity_reader_ra" {
  provider           = azurerm.identity
  scope              = "/subscriptions/${var.identity_subid}"
  role_definition_id = "${data.azurerm_subscription.identitysub.id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.identity_readers_group.id
}


resource "azurerm_role_assignment" "management_contributor_ra" {
  provider           = azurerm.management
  scope              = "/subscriptions/${var.management_subid}"
  role_definition_id = "${data.azurerm_subscription.managementsub.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azuread_group.management_contributors_group.id
}
resource "azurerm_role_assignment" "management_owner_ra" {
  provider           = azurerm.management
  scope              = "/subscriptions/${var.management_subid}"
  role_definition_id = "${data.azurerm_subscription.managementsub.id}${data.azurerm_role_definition.owner.id}"
  principal_id       = azuread_group.management_owners_group.id
}
resource "azurerm_role_assignment" "management_reader_ra" {
  provider           = azurerm.management
  scope              = "/subscriptions/${var.management_subid}"
  role_definition_id = "${data.azurerm_subscription.managementsub.id}${data.azurerm_role_definition.reader.id}"
  principal_id       = azuread_group.management_readers_group.id
}

