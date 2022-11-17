#panorama-sbox-ukw-rg
resource "azurerm_resource_group" "ctsc_rg" {
  name     = "${local.rg_name}-rg"
  location = var.location
}