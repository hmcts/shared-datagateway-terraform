resource "azurerm_automation_account" "ctsc_auto" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.ctsc_rg.name
  sku_name_workspace  = var.sku_name_workspace
  tags                = local.common_tags
}