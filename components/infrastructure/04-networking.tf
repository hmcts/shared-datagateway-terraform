# Subnet
data "azurerm_key_vault" "hub_azure_keyvault" {
  name                = "hmcts-infra-hub-${var.infra_hub_suffix}"
  resource_group_name = "hmcts-infra-hub-${var.infra_hub_suffix}"
}

data "azurerm_key_vault_secret" "hub_rg_name" {
  name         = "rg-name"
  key_vault_id = data.azurerm_key_vault.hub_azure_keyvault.id
}

data "azurerm_key_vault_secret" "hub_vnet_name" {
  name         = "vnet-name"
  key_vault_id = data.azurerm_key_vault.hub_azure_keyvault.id
}

data "azurerm_virtual_network" "vnet_data" {
  name                = data.azurerm_key_vault_secret.hub_vnet_name.value
  resource_group_name = data.azurerm_key_vault_secret.hub_rg_name.value
}

resource "azurerm_subnet" "gateway_subnet" {
  name                 = "ctsc-data-gateway"
  resource_group_name  = data.azurerm_virtual_network.vnet_data.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_data.name
  address_prefixes     = [var.subnet_prefix]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg_ctsc" {
  name                = local.nsg_name
  location            = azurerm_resource_group.ctsc_rg.location
  resource_group_name = azurerm_resource_group.ctsc_rg.name
  tags                = local.common_tags
}

# Network Security Group Association
resource "azurerm_subnet_network_security_group_association" "nsg_ctsc_association" {
  subnet_id                 = azurerm_subnet.gateway_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_ctsc.id
}

# Network Security group rule
resource "azurerm_network_security_rule" "ctsc_nsg_rules" {
  for_each = {
    for rule in local.nsg_security_rules : rule.name => rule
  }
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_ranges     = each.value.destination_port_ranges
  source_address_prefixes     = each.value.source_address_prefixes
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.ctsc_rg.name
  network_security_group_name = local.nsg_name
  description                 = each.value.description
}
