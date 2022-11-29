resource "azurerm_automation_account" "ctsc_auto" {
  name                = "ctsc-dgw-automation"
  location            = var.location
  resource_group_name = azurerm_resource_group.ctsc_rg.name
  sku_name_workspace  = "PerGB2018"
  log_retention_days  = "30"
  tags                = local.common_tags
}