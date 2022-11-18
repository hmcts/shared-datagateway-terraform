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

resource "azurerm_subnet" "pbi-data-gateway" {
  name                 = "pbi-data-gateway"
  resource_group_name  = data.azurerm_virtual_network.vnet_data.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet_data.name
  address_prefixes     = [var.subnet_prefix]
}

# Network Security Group
resource "azurerm_network_security_group" "nsg_ctsc" {
  name                = "nsg_ctsc"
  location            = azurerm_resource_group.ctsc_rg.location
  resource_group_name = azurerm_resource_group.ctsc_rg.name
  tags                = local.common_tags
}

# Network Security Group Association
resource "azurerm_subnet_network_security_group_association" "nsg_ctsc_association" {
  subnet_id                 = azurerm_subnet.pbi-data-gateway.id
  network_security_group_id = azurerm_network_security_group.nsg_ctsc.id
}
