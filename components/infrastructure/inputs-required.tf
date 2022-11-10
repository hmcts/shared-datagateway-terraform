# General
variable "env" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}
#
## Networking
#variable "bastion_cidr" {
#  type = string
#}
#
#variable "hub_vnets" {
#  type = map(string)
#}
#
#variable "network_address_space" {
#  type = string
#}
#
#variable "network_subnets" {
#  type = map(string)
#}
#
##variable "additional_routes" {
##  type = map(object({
##    name                   = string
##    address_prefix         = string
##    next_hop_type          = string
##    next_hop_in_ip_address = string
##  }))
##}
#
#
#
## Virtual machine
#variable "vm_size" {
#  type        = string
#  description = "Vm Instance size"
#}
#
#variable "log_collector_vm_size" {
#  type        = string
#  description = "Log collector Vm Instance size"
#  default     = "Standard_F16s_v2"
#}
#
#variable "vm_storage_account_type" {
#  type        = string
#  description = "Storage account type"
#  default     = "StandardSSD_LRS"
#}
#
#variable "vm_sku" {
#  type        = string
#  description = "Bring your own licence type"
#  default     = "byol"
#}
#
## Must always be greater or equal to FW version
#variable "vm_version" {
#  type        = string
#  description = "Panorama version"
#  default     = "latest"
#}
#
#variable "vm_count" {
#  type        = number
#  description = "Number of panorama vms to deploy, defaults to none"
#  default     = 0
#}
#
#variable "log_collector_vm_count" {
#  type        = number
#  description = "Number of log collector vms to deploy, defaults to none"
#  default     = 0
#}
#
#variable "vm_admin_username" {
#  type        = string
#  description = "Panorama vm admin usermane"
#  default     = "panadmin"
#}
#
#variable "vm_public_key" {
#  type        = string
#  description = "Panorama vm public key name"
#  default     = "panadmin-public-key"
#}
#
#variable "panorama_managed_disk" {
#  type        = map(string)
#  description = "Panorama managed disks used for sandbox"
#  default     = null
#}
#
#variable "log_collector_disks" {
#  type        = list(any)
#  description = "Log collector managed disk(s)"
#  default     = null
#}
#
## Private DNS
#variable "zone_name" {
#  type        = string
#  description = "DNS zone to manage"
#  default     = null
#}
#
#variable "zone_resource_group_name" {
#  type        = string
#  description = "Name of the resource group that contains the DNS zones."
#  default     = "core-infra-intsvc-rg"
#}
#
#variable "ttl" {
#  type        = number
#  description = "DNS time to live"
#  default     = 300
#}
#
#variable "create_dns_record" {
#  type        = bool
#  description = "Flag to create a zone record"
#  default     = true
#}
#
## Default route variables
#variable "route_name" {
#  type        = string
#  default     = "default"
#  description = "Default route name"
#}
#
#variable "route_address_prefix" {
#  type    = string
#  default = "0.0.0.0/0"
#}
#
#variable "route_next_hop_type" {
#  type    = string
#  default = "VirtualAppliance"
#}
#
#variable "route_next_hop_in_ip_address" {
#  type        = string
#  description = "Next hop to firewall lb"
#}
