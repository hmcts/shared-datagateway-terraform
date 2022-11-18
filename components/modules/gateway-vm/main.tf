# Provider Block
provider "azurerm" {
  features {}
}

resource "azurerm_windows_virtual_machine" "ctsc_vm" {
  for_each = {
    for idx, entry in var.vm_zones : "ctsc-vm-${entry.vm_count}" => entry
  }

  name                = "ctsc-datagateway-vm${each.value.vm_count}"
  resource_group_name = var.ctsc_rg_name
  location            = var.ctsc_rg_location
  size                = var.vmsize
  admin_username      = var.vm_admin_user
  admin_password      = var.vm_admin_password
  tags                = var.tags
  zone                = each.value.vm_zone
  network_interface_ids = [
    azurerm_network_interface.ctsc_nic["ctsc-nic-${each.value.vm_count}"].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  #  CIS Microsoft Windows Server 2019 STIG Benchmark
  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }
}


module "vm-bootstrap" {
  source = "git::https://github.com/hmcts/terraform-module-vm-bootstrap.git?ref=master"

  for_each = {
    for idx, entry in var.vm_zones : "ctsc-bootstrap-${entry.vm_count}" => entry
  }

  virtual_machine_type         = "vm"
  virtual_machine_id           = azurerm_windows_virtual_machine.ctsc_vm["ctsc-vm-${each.value.vm_count}"].id
  splunk_username              = var.splunk_username
  splunk_password              = var.splunk_password
  splunk_pass4symmkey          = var.splunk_pass4symmkey
  splunk_group                 = "hmcts_forwarders"
  os_type                      = local.os_type
  nessus_server                = var.nessus_server
  nessus_key                   = var.nessus_key
  nessus_groups                = var.nessus_groups
  install_dynatrace_oneagent   = false
  install_azure_monitor        = false
}
