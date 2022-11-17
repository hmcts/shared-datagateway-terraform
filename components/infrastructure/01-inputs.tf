variable "location" {
  type    = string
  default = "UK South"
}

variable "environment" {
  type = string
}

variable "subnet_prefix" {
  type = string
}

variable "hub_subscription_id" {
  type = string
}

# General
variable "builtFrom" {
  type    = string
  default = "hmcts/ctsc-datagateway-terraform"
}

variable "product" {
  type    = string
  default = "ctsc"
}

variable "project" {
  type    = string
  default = "ctsc"
}

variable "env" {
  type = string
}

#
#variable "dns_zone_subscription_id" {
#  type = string
#  # DTS-CFTSBOX-INTSVC
#  default = "1497c3d7-ab6d-4bb7-8a10-b51d03189ee3"
#}
#
## Management
#variable "mgmt_subscription_id" {
#  type = string
#  # Reform-CFT-Mgmt
#  default = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
#}

#variable "mgmt_vnet_name" {
#  type    = string
#  default = "core-infra-vnet-mgmt"
#}
#
#variable "mgmt_vnet_rg_name" {
#  type    = string
#  default = "rg-mgmt"
#}
#
## Networking
#variable "additional_hub_vnets" {
#  type    = map(string)
#  default = {}
#}
#
#variable "hub_uks_vnets" {
#  type    = map(string)
#  default = {}
#}
