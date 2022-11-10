
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





module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "2.0.0"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  root_parent_id = var.parent_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  deploy_core_landing_zones   = true
  deploy_corp_landing_zones   = true
  deploy_online_landing_zones = true

  deploy_management_resources    = true
  subscription_id_management     = data.azurerm_client_config.management.subscription_id
  configure_management_resources = local.configure_management_resources

  deploy_connectivity_resources    = true
  subscription_id_connectivity     = data.azurerm_client_config.connectivity.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

  deploy_identity_resources    = true
  subscription_id_identity     = data.azurerm_client_config.identity.subscription_id
  configure_identity_resources = local.configure_identity_resources

  subscription_id_overrides = {
    sandboxes = var.sandboxes,
    corp      = var.corp_subs
  }

  template_file_variables = {
    listOfAllowedLocations = var.allowed_locations
  }
}




# add a "services" subnet in each region hub
resource "azurerm_subnet" "hub_services" {
  for_each = module.enterprise_scale.azurerm_virtual_network.connectivity
  provider = azurerm.connectivity

  name                                           = "services"
  resource_group_name                            = each.value.resource_group_name
  virtual_network_name                           = each.value.name
  address_prefixes                               = tolist([local.network_config[each.value.location].Subnets["Services"]])
  enforce_private_link_endpoint_network_policies = true
}




resource "azurerm_local_network_gateway" "localvnetgw" {
  for_each = module.enterprise_scale.azurerm_virtual_network.connectivity
  provider = azurerm.connectivity

  name                = lower(join("-", [var.root_id, "lngw", each.value.location]))
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  gateway_fqdn        = var.gateway_fqdn
  address_space       = tolist([local.network_config.OnPremNetworkAddressSpace])
}





resource "azurerm_virtual_network_gateway_connection" "vnetgwconn" {
  for_each = module.enterprise_scale.azurerm_virtual_network_gateway.connectivity
  provider = azurerm.connectivity

  name                = lower(join("-", [var.root_id, "lgwc", each.value.location]))
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = each.value.id
  local_network_gateway_id   = "/subscriptions/${data.azurerm_client_config.connectivity.subscription_id}/resourceGroups/${var.root_id}-connectivity-${each.value.location}/providers/Microsoft.Network/localNetworkGateways/${lower(join("-", [var.root_id, "lngw", each.value.location]))}"

  shared_key = var.vpn_gw_shared_key
}




resource "azurerm_resource_group" "forefront_platform_resources" {
  for_each = module.enterprise_scale.azurerm_virtual_network.connectivity

  provider = azurerm.identity
  name     = lower(join("-", ["ff-plat", each.value.location]))
  location = each.value.location
}


resource "random_id" "keyvault" {
  keepers = {
    suffix = var.key_vault_id
  }

  byte_length = 4
}




resource "azurerm_key_vault" "forefront_platform_key_vault" {
  for_each = module.enterprise_scale.azurerm_virtual_network.connectivity
  provider = azurerm.identity

  name                            = lower(join("-", ["plat", each.value.location, random_id.keyvault.id]))
  location                        = each.value.location
  resource_group_name             = lower(join("-", ["ff-plat", each.value.location]))
  sku_name                        = "premium"
  tenant_id                       = data.azurerm_client_config.connectivity.tenant_id
  soft_delete_retention_days      = 7
  enabled_for_disk_encryption     = true
  purge_protection_enabled        = true
  enabled_for_deployment          = false
  enabled_for_template_deployment = false

  timeouts {
    delete = "20m"
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = concat(var.approved_ips, var.build_agent_ip, local.current_cidr)
    # the following means we use Service Endpoints. This is necessary since we can't disable public access completely 
    # if creating a Key Vaults with Key Vault keys across two regions
    virtual_network_subnet_ids = [for s in module.enterprise_scale.azurerm_subnet.connectivity : s.id if s.name != "AzureFirewallSubnet" && s.name != "GatewaySubnet"]
  }

}


resource "azurerm_key_vault_access_policy" "contributors_access" {
  for_each = azurerm_key_vault.forefront_platform_key_vault
  provider = azurerm.identity

  key_vault_id = each.value.id
  tenant_id    = data.azurerm_client_config.connectivity.tenant_id
  object_id    = azuread_group.connectivity_contributors_group.id

  key_permissions = [
    "Backup", "Create", "Delete", "Get", "Import", "List", "Recover", "Restore", "Update"
  ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Recover", "Restore", "Set"
  ]

  certificate_permissions = [
    "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Recover", "Restore", "SetIssuers", "Update"
  ]

}


resource "azurerm_key_vault_key" "platform_disk_encryption_key" {
  for_each = azurerm_key_vault.forefront_platform_key_vault
  provider = azurerm.identity

  name         = "plat-disk-enc-key-${each.value.location}"
  key_vault_id = each.value.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [
    azurerm_key_vault.forefront_platform_key_vault
  ]
}

resource "azurerm_disk_encryption_set" "platform_disk_encryption_set" {
  for_each = azurerm_key_vault.forefront_platform_key_vault
  provider = azurerm.connectivity

  name                = "plat-des-${each.value.location}"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  key_vault_key_id    = azurerm_key_vault_key.platform_disk_encryption_key[each.key].id

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_key_vault.forefront_platform_key_vault
  ]
}



# add a "services" subnet in each region hub
resource "azurerm_subnet" "endpoints" {
  for_each = module.enterprise_scale.azurerm_virtual_network.connectivity
  provider = azurerm.connectivity

  name                                      = local.network_config.EndpointsSubnetName
  resource_group_name                       = each.value.resource_group_name
  virtual_network_name                      = each.value.name
  address_prefixes                          = tolist([local.network_config[each.value.location].Subnets["Endpoints"]])
  private_endpoint_network_policies_enabled = false

}


data "azurerm_private_dns_zone" "kvdnszone" {
  provider = azurerm.connectivity

  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = "${var.root_id}-dns"
}


resource "azurerm_private_endpoint" "kv_private_endpoint" {
  for_each = azurerm_key_vault.forefront_platform_key_vault
  provider = azurerm.connectivity

  name                = lower(join("-", ["kvpe", each.value.location, random_id.keyvault.id]))
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = "/subscriptions/${data.azurerm_client_config.connectivity.subscription_id}/resourceGroups/${var.root_id}-connectivity-${each.value.location}/providers/Microsoft.Network/virtualNetworks/${var.root_id}-hub-${each.value.location}/subnets/${local.network_config.EndpointsSubnetName}"

  private_service_connection {
    name                           = lower(join("-", ["kvpepc", each.value.location, random_id.keyvault.id]))
    private_connection_resource_id = each.value.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = lower(join("-", ["dnszg", each.value.location, random_id.keyvault.id]))
    private_dns_zone_ids = [data.azurerm_private_dns_zone.kvdnszone.id]
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}