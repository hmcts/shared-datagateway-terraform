resource "azurerm_resource_group" "ctsc_rg" {
  name     = format("ctsc-%s-%s-rg", var.env, local.location_abrv)
  location = var.location
  tags     = local.common_tags
}
