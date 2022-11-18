module "ctsc" {
  source            = "../modules/gateway-vm"
  location          = var.location
  environment       = var.environment
  ctsc_rg_location  = azurerm_resource_group.ctsc_rg.location
  ctsc_rg_name      = azurerm_resource_group.ctsc_rg.name
  subnet_id         = azurerm_subnet.pbi-data-gateway.id
  vm_zones          = var.vm_zones
  vm_admin_user     = data.azurerm_key_vault_secret.vm_admin_user.value
  vm_admin_password = data.azurerm_key_vault_secret.vm_admin_password.value
  tags              = local.common_tags
  vm_offer          = var.vm_offer
  vm_publisher      = var.vm_publisher
  vm_sku            = var.vm_sku
  vm_version        = var.vm_version
  vm_publisher_name = var.vm_publisher_name
  install_splunk_uf        = var.install_splunk_uf
  splunk_username          = try(data.azurerm_key_vault_secret.splunk_username[0].value, null)
  splunk_password          = try(data.azurerm_key_vault_secret.splunk_password[0].value, null)
  splunk_pass4symmkey      = try(data.azurerm_key_vault_secret.splunk_pass4symmkey[0].value, null)
  nessus_install                   = var.nessus_install
  nessus_server                    = var.nessus_server
  nessus_key                       = try(data.azurerm_key_vault_secret.nessus_key[0].value, null)
  nessus_groups                    = var.nessus_groups
}

