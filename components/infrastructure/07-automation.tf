resource "azurerm_automation_account" "ctsc_auto" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.ctsc_rg.name
  sku_name            = var.sku_name
  tags                = local.common_tags
}
resource "azurerm_log_analytics_workspace" "ctsc_workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.ctsc_rg.name
  sku                 = var.sku_name_workspace
  retention_in_days   = var.log_retention_days
}

# Associate workspace and automation account
resource "azurerm_log_analytics_linked_service" "automation_workspace_assoc" {
  resource_group_name = data.azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.ctsc_workspace.id
  read_access_id      = azurerm_automation_account.ctsc_auto.id
}