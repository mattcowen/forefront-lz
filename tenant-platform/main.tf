
locals {
  network_config = {
    "uksouth" = {
      HubVnetAddressSpace = ["10.100.0.0/16"]
      Subnets = {
        AzureFirewallSubnet = "10.100.0.0/24"
        GatewaySubnet       = "10.100.1.0/24"
        Services            = "10.100.2.0/24"
        Endpoints           = "10.100.3.0/24"
      }
      VpnGwAddressSpace = "10.99.0.0/24"
    }
    "ukwest" = {
      HubVnetAddressSpace = ["10.101.0.0/16"]
      Subnets = {
        AzureFirewallSubnet = "10.101.0.0/24"
        GatewaySubnet       = "10.101.1.0/24"
        Services            = "10.101.2.0/24"
        Endpoints           = "10.101.3.0/24"
      }
      VpnGwAddressSpace = "10.98.0.0/24"
    }
    OnPremNetworkAddressSpace = "192.168.1.0/24"
    EndpointsSubnetName       = "endpoints"
  }
}

data "external" "myip" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

locals {
  current_ip   = data.external.myip.result.ip
  current_cidr = ["${data.external.myip.result.ip}/32"]
}


module "enterprise_scale_platform" {
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

  deploy_management_resources    = true
  subscription_id_management     = data.azurerm_client_config.management.subscription_id
  configure_management_resources = local.configure_management_resources

  deploy_connectivity_resources    = true
  subscription_id_connectivity     = data.azurerm_client_config.connectivity.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources


  deploy_identity_resources     = false
  
  template_file_variables = {
    listOfAllowedLocations = var.allowed_locations
  }
}
