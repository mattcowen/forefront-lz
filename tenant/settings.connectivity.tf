locals {
  configure_connectivity_resources = {
    settings = {
      hub_networks = [
        {
          enabled = true
          config = {
            address_space                = var.hub_vnet_address_space
            location                     = var.connectivity_resources_location
            link_to_ddos_protection_plan = false
            dns_servers                  = []
            bgp_community                = ""
            subnets                      = []
            virtual_network_gateway = {
              enabled = true
              config = {
                address_prefix           = var.vnetgw_address_space
                gateway_sku_expressroute = ""
                gateway_sku_vpn          = "VpnGw3"
              }
            }
            azure_firewall = {
              enabled = true
              config = {
                address_prefix    = var.azfw_address_space
                enable_dns_proxy  = true
                threat_intel_mode = var.azfw_threat_intel_mode
                availability_zones = {
                  zone_1 = true
                  zone_2 = false
                  zone_3 = false
                }
              }
            }
            spoke_virtual_network_resource_ids      = []
            enable_outbound_virtual_network_peering = false
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
          location = var.connectivity_resources_location
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
          private_link_locations                                 = []
          public_dns_zones                                       = []
          private_dns_zones                                      = []
          enable_private_dns_zone_virtual_network_link_on_hubs   = true
          enable_private_dns_zone_virtual_network_link_on_spokes = true
        }
      }
    }
    location = null
    tags     = null
    advanced = null
  }
}