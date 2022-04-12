variable "resource_group_name" {
  type    = string
  default = "ffeslz-mgmt"
}

variable "resource_region" {
  type    = string
  default = "uksouth"
}

variable "state_sa_name" {
  type    = string
  default = "ffeslzstates"
}

variable "shared_acr_name" {
  type    = string
  default = "ffeslzacr"
}

variable "shared_keyvault_name" {
  type    = string
  default = "ffeslzkv"
}

variable "sc_keyvault_sp_name" {
  type    = string
  default = "ffeslz-kv-sp"
}
