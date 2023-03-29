resource "azurerm_automation_account" "shared_dgw_auto" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.shared-datagateway-rg.name
  sku_name            = var.sku_name
  tags                = local.common_tags
}

resource "azurerm_log_analytics_workspace" "shared_dgw_workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.shared-datagateway-rg.name
  sku                 = var.sku_name_workspace
  retention_in_days   = var.log_retention_days
}

# Associate workspace and automation account
resource "azurerm_log_analytics_linked_service" "automation_workspace_assoc" {
  resource_group_name = azurerm_resource_group.shared-datagateway-rg.name
  workspace_id        = azurerm_log_analytics_workspace.shared_dgw_workspace.id
  read_access_id      = azurerm_automation_account.shared_dgw_auto.id
}