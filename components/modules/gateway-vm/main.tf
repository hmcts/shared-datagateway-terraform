# Provider Block
provider "azurerm" {
  features {}
}

resource "azurerm_windows_virtual_machine" "ctsc_vm" {
  for_each            = local.zones
  name                = "ctsc-machine"
  resource_group_name = var.ctsc_rg_name
  location            = var.ctsc_rg_location
  size                = var.vmsize
  admin_username      = var.vm_admin_user
  admin_password      = var.vm_admin_password
  tags                = var.tags
  zone                = each.value
  network_interface_ids = [
    azurerm_network_interface.ctsc_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  #  CIS Microsoft Windows Server 2019 STIG Benchmark

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}






