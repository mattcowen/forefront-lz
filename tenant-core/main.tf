module "init1_enterprise_scale" {
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
  
  deploy_core_landing_zones     = true

  deploy_management_resources   = false
  deploy_connectivity_resources = false
  deploy_identity_resources     = false
  
  template_file_variables = {
    listOfAllowedLocations = var.allowed_locations
  }
}
