
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
variable "management_subid"{
  type = string
}
variable "identity_subid" {
  type = string
}
variable "log_retention_in_days" {
  type    = number
  default = 90
}
variable "security_alerts_email_address" {
  type    = string
}
variable "management_resources_location" {
  type    = string
}
variable "connectivity_resources_location" {
  type    = string
}
variable "management_resources_tags" {
  type = map(string)
  default = {
  }
}
variable "azfw_threat_intel_mode"{
  type = string
  default = "Deny" # Alert, Off, Deny
}

variable "hub_vnet_address_space" {
  type = list(string)
  default = ["10.100.0.0/16", ]
}
variable "vnetgw_address_space" {
  type = string
  default = "10.100.1.0/24"
}
variable "azfw_address_space" {
  type = string
  default = "10.100.0.0/24"
}
variable "landing_zone_subs" {
  type = list(string)
  default = []
}

variable "sandboxes"{
  type = list(string)
  default = []
}