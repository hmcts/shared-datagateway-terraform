# NIC
resource "azurerm_network_interface" "shared_dgw_nic" {
  for_each = {
    for idx, entry in var.vm_zones : "shared-dgw-nic-${entry.vm_count}" => entry
  }

  name                = format("%s-%s-nic-%s", var.project, local.location_abrv, each.value.vm_count)
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

