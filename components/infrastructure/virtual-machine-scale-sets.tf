module "windows-vm-ss" {
  for_each = var.vm_scale_sets
  source   = "git::https://github.com/hmcts/terraform-module-virtual-machine-scale-set.git?ref=main"
  providers = {
    azurerm.cnp = azurerm.cnp
    azurerm.soc = azurerm.soc
    azurerm     = azurerm
    azurerm.dcr = azurerm.dcr
  }

  vm_type              = "windows-scale-set"
  vm_name              = each.key
  computer_name_prefix = "windatagw"
  vm_resource_group    = local.rg_name
  vm_sku               = each.value.vm_sku
  vm_admin_password    = random_password.vm_password[each.key].result
  vm_availabilty_zones = each.value.vm_availabilty_zones
  vm_publisher_name    = "MicrosoftWindowsServer"
  vm_offer             = "WindowsServer"
  vm_image_sku         = "2022-Datacenter"
  vm_version           = "latest"
  vm_instances         = each.value.vm_instances
  network_interfaces   = each.value.network_interfaces
  managed_disks        = each.value.managed_disks
  kv_name              = azurerm_key_vault.shared-dgw-key-vault.name
  kv_rg_name           = azurerm_resource_group.shared-datagateway-rg.name
  encrypt_ADE          = false
  install_splunk_uf    = var.install_splunk_uf
  splunk_username      = try(data.azurerm_key_vault_secret.splunk_username[0].value, null)
  splunk_password      = try(data.azurerm_key_vault_secret.splunk_password[0].value, null)
  splunk_pass4symmkey  = try(data.azurerm_key_vault_secret.splunk_pass4symmkey[0].value, null)
  nessus_install       = var.nessus_install
  nessus_server        = var.nessus_server
  nessus_key           = try(data.azurerm_key_vault_secret.nessus_key[0].value, null)
  nessus_groups        = var.nessus_groups
  environment          = var.environment

  # Dynatrace OneAgent
  install_dynatrace_oneagent = true
  dynatrace_hostgroup        = "PlatOps_Data_Gateway_ScaleSets"
  dynatrace_tenant_id        = var.dynatrace_tenant_id
  dynatrace_token            = data.azurerm_key_vault_secret.token.value
  dynatrace_server           = var.dynatrace_server

  install_azure_monitor   = false
  systemassigned_identity = true
  upgrade_mode            = "Automatic"
  tags                    = module.ctags.common_tags
}
