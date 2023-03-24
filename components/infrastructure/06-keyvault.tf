
data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "shared_dgw_kv" {
  name                = azurerm_key_vault.shared-dgw-key-vault.name
  resource_group_name = azurerm_resource_group.shared-datagateway-rg.name
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "shared-dgw-admin-password"
  key_vault_id = data.azurerm_key_vault.shared_dgw_kv.id
}

data "azurerm_key_vault_secret" "vm_admin_user" {
  name         = "shared-dgw-admin-user"
  key_vault_id = data.azurerm_key_vault.shared_dgw_kv.id
}

resource "azurerm_key_vault" "shared-dgw-key-vault" {
  name                            = format("shared-dgw-%s-%s-kv", var.environment, local.location_abrv)
  location                        = var.location
  resource_group_name             = azurerm_resource_group.shared-datagateway-rg.name
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days      = 7
  sku_name                        = "standard"
  tags                            = local.common_tags
}


