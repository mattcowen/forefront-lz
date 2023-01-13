locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = local.network_config[var.connectivity_resources_location_1].HubVnetAddressSpace
            location                     = var.connectivity_resources_location_1
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix             = var.vnetgw_address_space_1
                gateway_sku_expressroute   = ""
                gateway_sku_vpn            = "VpnGw1AZ"
                private_ip_address_enabled = false
                advanced_vpn_settings = {
                  enable_bgp                       = false
                  active_active                    = false
                  private_ip_address_allocation    = ""
                  default_local_network_gateway_id = ""
                  vpn_client_configuration = [
                    {
                      aad_audience          = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
                      aad_issuer            = "https://sts.windows.net/dcd5d5df-cb89-42a7-85cc-e3b113d4aad1/"
                      aad_tenant            = "https://login.microsoftonline.com/dcd5d5df-cb89-42a7-85cc-e3b113d4aad1/"
                      address_space         = tolist([var.vpn_client_address_space_1])
                      vpn_auth_types        = ["AAD"]
                      vpn_client_protocols  = ["OpenVPN"]
                      radius_server_address = null
                      radius_server_secret  = null
                      revoked_certificate   = []
                      root_certificate      = []
                    }
                  ]
                  bgp_settings = []
                  custom_route = []
                }
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                address_prefix                = var.azfw_address_space_1
                enable_dns_proxy              = true
                threat_intel_mode             = var.azfw_threat_intel_mode
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = []
                availability_zones = {
                  zone_1 = false
                  zone_2 = false
                  zone_3 = false
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
            enable_hub_network_mesh_peering         = true
          }
        },
        {
          enabled = true
          config = {
            address_space                = local.network_config[var.connectivity_resources_location_2].HubVnetAddressSpace
            location                     = var.connectivity_resources_location_2
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix             = var.vnetgw_address_space_2
                gateway_sku_expressroute   = ""
                gateway_sku_vpn            = "VpnGw3"
                private_ip_address_enabled = false
                advanced_vpn_settings = {
                  enable_bgp                       = false
                  active_active                    = false
                  private_ip_address_allocation    = ""
                  default_local_network_gateway_id = ""
                  vpn_client_configuration = [
                    {
                      aad_audience          = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
                      aad_issuer            = "https://sts.windows.net/dcd5d5df-cb89-42a7-85cc-e3b113d4aad1/"
                      aad_tenant            = "https://login.microsoftonline.com/dcd5d5df-cb89-42a7-85cc-e3b113d4aad1/"
                      address_space         = tolist([var.vpn_client_address_space_2])
                      vpn_auth_types        = ["AAD"]
                      vpn_client_protocols  = ["OpenVPN"]
                      radius_server_address = null
                      radius_server_secret  = null
                      revoked_certificate   = []
                      root_certificate      = []
                    }
                  ]
                  bgp_settings = []
                  custom_route = []
                }
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                address_prefix    = var.azfw_address_space_2
                enable_dns_proxy  = true
                threat_intel_mode = var.azfw_threat_intel_mode
                availability_zones = {
                  zone_1 = false
                  zone_2 = false
                  zone_3 = false
                }
                dns_servers                   = []
                sku_tier                      = ""
                base_policy_id                = ""
                private_ip_ranges             = []
                threat_intelligence_mode      = ""
                threat_intelligence_allowlist = []
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
            enable_hub_network_mesh_peering         = true
          }
        }
      ]
      vwan_hub_networks = []
      ddos_protection_plan = {
        enabled = false
        config = {
          location = ""
        }
      }
      dns = {
        enabled = true
        config = {
          location = var.connectivity_resources_location_1
          enable_private_link_by_service = {
            azure_automation_webhook             = true
            azure_automation_dscandhybridworker  = true
            azure_sql_database_sqlserver         = true
            azure_synapse_analytics_sqlserver    = true
            azure_synapse_analytics_sql          = true
            storage_account_blob                 = true
            storage_account_table                = true
            storage_account_queue                = true
            storage_account_file                 = true
            storage_account_web                  = true
            azure_data_lake_file_system_gen2     = true
            azure_cosmos_db_sql                  = true
            azure_cosmos_db_mongodb              = true
            azure_cosmos_db_cassandra            = true
            azure_cosmos_db_gremlin              = true
            azure_cosmos_db_table                = true
            azure_database_for_postgresql_server = true
            azure_database_for_mysql_server      = true
            azure_database_for_mariadb_server    = true
            azure_key_vault                      = true
            azure_kubernetes_service_management  = true
            azure_search_service                 = true
            azure_container_registry             = true
            azure_app_configuration_stores       = true
            azure_backup                         = true
            azure_site_recovery                  = true
            azure_event_hubs_namespace           = true
            azure_service_bus_namespace          = true
            azure_iot_hub                        = true
            azure_relay_namespace                = true
            azure_event_grid_topic               = true
            azure_event_grid_domain              = true
            azure_web_apps_sites                 = true
            azure_machine_learning_workspace     = true
            signalr                              = true
            azure_monitor                        = true
            cognitive_services_account           = true
            azure_file_sync                      = true
            azure_data_factory                   = true
            azure_data_factory_portal            = true
            azure_cache_for_redis                = true
          }
          private_link_locations                                 = var.allowed_locations
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
        }
      }
    }
    location = null
    tags     = null
    advanced = {
      custom_settings_by_resource_type = {
        azurerm_subnet = {
          connectivity = {
            uksouth = {
              Services = {
                private_endpoint_network_policies_enabled = true
              }
            }
          }
        }

      }
    }
  }
}