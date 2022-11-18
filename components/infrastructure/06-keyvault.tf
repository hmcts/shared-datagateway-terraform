
data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "ctsc_kv" {
  name                = azurerm_key_vault.ctsc_key_vault.name
  resource_group_name = azurerm_resource_group.ctsc_rg.name
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "ctsc-admin-password"
  key_vault_id = data.azurerm_key_vault.ctsc_kv.id
}

data "azurerm_key_vault_secret" "vm_admin_user" {
  name         = "ctsc-admin-user"
  key_vault_id = data.azurerm_key_vault.ctsc_kv.id
}

resource "azurerm_key_vault" "ctsc_key_vault" {
  name                            = format("ctsc-%s-%s-kv", var.env, local.location_abrv)
  location                        = var.location
  resource_group_name             = azurerm_resource_group.ctsc_rg.name
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  sku_name                        = "standard"
  tags                            = local.common_tags
}


