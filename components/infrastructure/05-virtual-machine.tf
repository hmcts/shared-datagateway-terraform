#module "ctsc" {
#  source           = "../modules/gateway-vm"
#  location         = var.location
#  environment      = var.env
#  ctsc_rg_location = azurerm_resource_group.ctsc_rg.location
#  ctsc_rg_name     = azurerm_resource_group.ctsc_rg.name
#  subnet_id        = azurerm_subnet.pbi-data-gateway.id
#  admin_password   = data.azurerm_key_vault_secret.vm_admin_password.value
#  tags             = local.common_tags
#}
#
#resource "azurerm_network_interface" "ctsc_nic" {
#  name                = "ctsc-nic"
#  location            = azurerm_resource_group.ctsc_rg.location
#  resource_group_name = azurerm_resource_group.ctsc_rg.name
#
#  ip_configuration {
#    name                          = "internal"
#    subnet_id                     = azurerm_subnet.subnet-pbi-data-gateway.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}

