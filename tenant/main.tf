

# Call the caf-enterprise-scale module directly from the Terraform Registry
# pinning to the latest version

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.1"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  root_parent_id = var.parent_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  deploy_core_landing_zones      = true
  deploy_corp_landing_zones      = true
  deploy_online_landing_zones    = true

  deploy_management_resources    = true
  subscription_id_management     = data.azurerm_client_config.management.subscription_id
  configure_management_resources = local.configure_management_resources

  deploy_connectivity_resources  = true
  subscription_id_connectivity   = data.azurerm_client_config.connectivity.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

  deploy_identity_resources      = true
  subscription_id_identity       = data.azurerm_client_config.identity.subscription_id
  configure_identity_resources   = local.configure_identity_resources

  subscription_id_overrides = {
    landing-zones = var.landing_zone_subs,
    sandboxes = var.sandboxes
  }
}
