data "azurerm_resource_group" "ctsc_rg" {
}
resource "azurerm_automation_account" "example" {
  name                = "ctsc-dgw-automation"
  location            = var.location
  resource_group_name = ctsc_rg.resource_group_name
  sku_name_workspace  = "PerGB2018"
  log_retention_days  = "30"

  tags = merge(local.common_tags, local.extra_tags, local.enforced_tags)
}
