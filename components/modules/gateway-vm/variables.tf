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

variable "ctsc_rg_location" {
  type = string
}

variable "ctsc_rg_name" {
  type = string
}

variable "tags" {
  type        = any
  description = "Resource tag values"
  default     = {}
}

variable "location" {
  type    = string
  default = "UK South"
}

variable "environment" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "subnet id"
}

# Virtual Machine
variable "vm_size" {
  type        = string
  description = "Vm Instance size"
  default     = "Standard_D3_v2"
}

variable "vm_storage_account_type" {
  type        = string
  description = "Storage account type"
  default     = "StandardSSD_LRS"
}

variable "vm_admin_user" {
  type        = string
  description = "ctsc vm admin username, defaults to 'ctscadmin'"
}

variable "vm_admin_password" {
  type        = string
  description = "admin_password"
}

variable "vm_publisher" {
  type = string
}

variable "vm_offer" {
  type = string
}

variable "vm_sku" {
  type = string
}

variable "vm_version" {
  type = string
}

variable "vm_zones" {
  type = list(object({
    vm_count = string,
    vm_zone  = string
  }))
  description = "Zone and VM entry detail"
}

variable "vm_publisher_name" {
  type = string
}

variable "os_type" {
  default = null
}

# Splunk
variable "install_splunk_uf" {
  type = bool
}

variable "splunk_username" {
  type = string
}

variable "splunk_password" {
  type = string
}

variable "splunk_pass4symmkey" {
  type = string
}

# Dynatrace
variable "install_dynatrace_oa" {
  default = false
}

variable "tenant_id" {
  default = null
}

variable "token" {
  default = null
}

variable "server" {
  default = null
}

variable "hostgroup" {
  default = null
}

# Nessus
variable "nessus_install" {
  type = bool
}

variable "nessus_server" {
  type = string
}

variable "nessus_key" {
  type = string
}

variable "nessus_groups" {
  type = string
}

# Locals
locals {
  location_abrv        = lower(join("", regex("^([a-zA-Z]+).*\\s([a-zA-Z])[a-zA-Z]+$", var.location)))
  os_type              = var.os_type == null ? substr(var.vm_publisher_name, 0, 9) == "Microsoft" ? "Windows" : "Linux" : var.os_type
  resource_name_prefix = format("%s-%s-%s", var.project, var.environment, local.location_abrv)
}