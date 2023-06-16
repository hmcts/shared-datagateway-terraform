#panorama-sbox-ukw-rg
resource "azurerm_resource_group" "shared-datagateway-rg" {
  name     = var.environment == "prod" ? local.rg_name_prod : local.rg_name_nonprod
  location = var.location
}