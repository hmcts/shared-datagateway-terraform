#panorama-sbox-ukw-rg
resource "azurerm_resource_group" "shared-datagateway-rg" {
  name     = local.rg_name
  location = var.location
}