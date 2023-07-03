
data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "shared_dgw_kv" {
  name                = azurerm_key_vault.shared-dgw-key-vault.name
  resource_group_name = azurerm_resource_group.shared-datagateway-rg.name
}

data "azurerm_key_vault_secret" "vm_admin_password" {
  name         = "${var.project}-admin-password"
  key_vault_id = data.azurerm_key_vault.shared_dgw_kv.id
}

data "azurerm_key_vault_secret" "vm_admin_user" {
  name         = "${var.project}-admin-user"
  key_vault_id = data.azurerm_key_vault.shared_dgw_kv.id
}

resource "azurerm_key_vault" "shared-dgw-key-vault" {
  name                            = format("shared-dgw-%s", var.environment)
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


resource "random_password" "vm_password" {
  for_each         = var.vm_scale_sets
  length           = 16
  special          = true
  override_special = "#$%&@()_[]{}<>:?"
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "vm_password_secret" {
  for_each     = var.vm_scale_sets
  name         = "${each.key}-vm-password"
  value        = random_password.vm_password[each.key].result
  key_vault_id = data.azurerm_key_vault.shared_dgw_kv.id
}

# resource "azurerm_key_vault_access_policy" "identity_access" {
#   for_each           = var.vm_scale_sets
#   key_vault_id       = data.azurerm_key_vault.shared_dgw_kv.id
#   tenant_id          = data.azurerm_client_config.current.tenant_id
#   object_id          = module.windows-vm-ss[each.key].principal_id
#   secret_permissions = ["Get", "Set", "List"]
#   depends_on         = [module.windows-vm-ss]
# }
