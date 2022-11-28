
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
