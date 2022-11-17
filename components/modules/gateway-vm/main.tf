# Provider Block
provider "azurerm" {
  features {}
}

# Availability set
resource "azurerm_availability_set" "ctsc_vm_avset" {
  name                         = format("%s-avset", local.resource_name_prefix)
  location                     = var.location
  resource_group_name          = local.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  tags                         = var.tags
}


resource "azurerm_windows_virtual_machine" "ctsc_vm" {
  name                = "ctsc-machine"
  resource_group_name = var.ctsc_rg_name
  location            = var.ctsc_rg_location
  size                = var.vmsize
  admin_username      = var.vm_admin_username
  admin_password      = var.admin_password
  tags                = var.tags
  availability_set_id = azurerm_availability_set.ctsc_vm_avset.id
  network_interface_ids = [
    azurerm_network_interface.ctsc_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}






