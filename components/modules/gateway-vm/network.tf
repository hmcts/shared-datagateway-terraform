# NIC
resource "azurerm_network_interface" "ctsc_nic" {
  name                = "ctsc-nic"
  location            = var.location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

