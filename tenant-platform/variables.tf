
# The parent mgmt group. The AAD tenant id is the default here.
# Allows scoping the TF identity to specific mgmt group branch rather than root.
variable "parent_id" {
  type = string
}
variable "root_name" {
  type = string
}
variable "root_id" {
  type = string
}
variable "connectivity_subid" {
  type = string
}
variable "management_subid" {
  type = string
}
variable "identity_subid" {
  type = string
}
variable "allowed_locations" {
  type = list(string)
  # ensure the primary location is specified first
  default = ["uksouth", "ukwest"]
}



variable "log_retention_in_days" {
  type    = number
  default = 90
}
variable "security_alerts_email_address" {
  type = string
}
variable "management_resources_location" {
  type = string
}
variable "connectivity_resources_location_1" {
  type = string
}
variable "connectivity_resources_location_2" {
  type = string
}

variable "private_dns_zones_url" {
  type    = string
  default = ""
}
variable "management_resources_tags" {
  type = map(string)
  default = {
  }
}
variable "azfw_threat_intel_mode" {
  type    = string
  default = "Deny" # Alert, Off, Deny
}

variable "hub_vnet_address_space_1" {
  type    = list(string)
  default = ["10.100.0.0/16", ]
}
variable "hub_vnet_address_space_2" {
  type    = list(string)
  default = ["10.101.0.0/16", ]
}
variable "hub_vnet_services_subnet_address_space_1" {
  type    = list(string)
  default = ["10.100.2.0/24"]
}
variable "hub_vnet_services_subnet_address_space_2" {
  type    = list(string)
  default = ["10.101.2.0/24"]
}

variable "azfw_address_space_1" {
  type    = string
  default = "10.100.0.0/24"
}
variable "azfw_address_space_2" {
  type    = string
  default = "10.101.0.0/24"
}

variable "vnetgw_address_space_1" {
  type    = string
  default = "10.100.1.0/24"
}
variable "vnetgw_address_space_2" {
  type    = string
  default = "10.101.1.0/24"
}
variable "vpn_client_address_space_1" {
  type    = string
  default = "10.99.99.0/24"
}
variable "vpn_client_address_space_2" {
  type    = string
  default = "10.99.98.0/24"
}

variable "sandboxes" {
  type    = list(string)
  default = []
}
variable "corp_subs" {
  type    = list(string)
  default = []
}

# user variables
variable "connectivity_subscription_owner" {
  type = string
}
variable "identity_subscription_owner" {
  type = string
}
variable "management_subscription_owner" {
  type = string
}
variable "build_agent_ip" {
  type    = list(string)
  default = []
}

variable "owner_role_name" {
  type    = string
  default = "Owner"
}

variable "contributor_role_name" {
  type    = string
  default = "Contributor"
}

variable "reader_role_name" {
  type    = string
  default = "Reader"
}

#Firewall Rules
variable "approved_ips" {
  type    = list(string)
  default = []
}

variable "key_vault_id" {
  type = string
}

variable "vpn_gw_shared_key" {
  type = string
}

variable "gateway_fqdn" {
  type = string
}

