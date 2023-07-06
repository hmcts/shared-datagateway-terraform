# General
variable "location" {
  type    = string
  default = "UK South"
}

variable "environment" {
  type = string
}

variable "infra_hub_suffix" {
  type    = string
  default = "nonprodi"
}

variable "subnet_prefix" {
  type = string
}

variable "hub_subscription_id" {
  type = string
}

variable "builtFrom" {
  type    = string
  default = "hmcts/shared-datagateway-terraform"
}

variable "buildEnv" {
  type    = string
  default = "stg"
}

variable "product" {
  type    = string
  default = "shared-datagateway"
}

variable "project" {
  type    = string
  default = "shared-dgw"
}

# Virtual Machine
variable "vm_size" {
  type        = string
  description = "Vm Instance size"
}

variable "vm_storage_account_type" {
  type        = string
  description = "Storage account type"
}

variable "vm_zones" {
  type = list(object({
    vm_count = string,
    vm_zone  = string
  }))
  description = "Zone and VM entry detail"
}

variable "env" {
  type = string
}

# Splunk
variable "install_splunk_uf" {
  default = false
}

variable "cnp_vault_rg" {
  type = string
}

variable "cnp_vault_sub" {
  type = string
}

# VM details
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

variable "vm_publisher_name" {
  type = string
}

# Nessus Agent
variable "nessus_install" {
  type    = bool
  default = false
}

variable "nessus_server" {
  type = string
}

variable "nessus_key_name" {
  type    = string
  default = null
}

variable "nessus_groups" {
  type = string
}

variable "automation_account_name" {
  type = string
}
variable "log_analytics_workspace_name" {
  type = string
}
variable "sku_name_workspace" {
  type = string
}
variable "log_retention_days" {
  type = number
}
variable "sku_name" {
  description = "The SKU name of the account - only Basic is supported at this time"
}

variable "subnet_service_endpoints" {
  default = [
    "Microsoft.Sql"
  ]
}
variable "vm_scale_sets" {
  description = "The VM Scale sets configuration variable"
  default     = {}
}
data "azurerm_key_vault" "soc_vault" {
  count    = var.install_splunk_uf ? 1 : 0
  provider = azurerm.soc

  name                = "soc-prod"
  resource_group_name = "soc-core-infra-prod-rg"
}

data "azurerm_key_vault_secret" "splunk_username" {
  count    = var.install_splunk_uf ? 1 : 0
  provider = azurerm.soc

  name         = "splunk-gui-admin-username"
  key_vault_id = data.azurerm_key_vault.soc_vault[0].id
}

data "azurerm_key_vault_secret" "splunk_password" {
  count    = var.install_splunk_uf ? 1 : 0
  provider = azurerm.soc

  name         = "splunk-gui-admin-password"
  key_vault_id = data.azurerm_key_vault.soc_vault[0].id
}

data "azurerm_key_vault_secret" "splunk_pass4symmkey" {
  count    = var.install_splunk_uf ? 1 : 0
  provider = azurerm.soc

  name         = "Splunk-pass4SymmKey"
  key_vault_id = data.azurerm_key_vault.soc_vault[0].id
}

data "azurerm_key_vault" "soc_vault2" {
  count    = var.nessus_install ? 1 : 0
  provider = azurerm.soc

  name                = "soc-prod"
  resource_group_name = "soc-core-infra-prod-rg"
}

data "azurerm_key_vault_secret" "nessus_key" {
  count    = var.nessus_install ? 1 : 0
  provider = azurerm.soc

  name         = var.nessus_key_name
  key_vault_id = data.azurerm_key_vault.soc_vault2[0].id
}

variable "dynatrace_tenant_id" {
  description = "The ID of the Dynatrace tenant"
  type        = string
  default     = ""
}

variable "dynatrace_server" {
  description = "The Dynatrace server address"
  type        = string
  default     = ""
}
