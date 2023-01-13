module "enterprise_scale_identity" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "2.4.1"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  root_parent_id = var.parent_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  strict_subscription_association = false
  
  deploy_core_landing_zones     = false

  deploy_management_resources   = false
  deploy_connectivity_resources = false
  
  deploy_identity_resources     = true
  subscription_id_identity     = data.azurerm_client_config.identity.subscription_id
  configure_identity_resources = local.configure_identity_resources

  
  custom_landing_zones = {
    "${var.root_id}" = {
      display_name               = "${var.root_name} Identity"
      parent_management_group_id = var.parent_id
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "es_root"
        parameters     = {}
        access_control = {}
      }
    },
    "${var.root_id}-platform" = {
      display_name               = "Platform"
      parent_management_group_id = "${var.root_id}"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "es_platform"
        parameters     = {}
        access_control = {}
      }
    },
    "${var.root_id}-identity" = {
      display_name               = "Identity"
      parent_management_group_id = "${var.root_id}-platform"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "es_identity"
        parameters     = {}
        access_control = {}
      }
    }
  }  

  template_file_variables = {
    listOfAllowedLocations = var.allowed_locations
  }
}
