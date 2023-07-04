resource "azurerm_virtual_machine_scale_set_extension" "azure_vmss_run_command" {
  for_each                     = var.vm_scale_sets
  name                         = "windows-run-command"
  virtual_machine_scale_set_id = module.windows-vm-ss[each.key].vm_id
  publisher                    = "Microsoft.CPlat.Core"
  type                         = "RunCommandWindows"
  type_handler_version         = "1.1"
  auto_upgrade_minor_version   = true
  protected_settings = jsonencode({
    script = compact(tolist([templatefile("${path.module}/scripts/gw_install.ps1", {
      Connect_Username    = local.moj_username
      Connect_Password    = local.moj_password
      TenantId            = local.moj_tenant_id
      InstanceName        = data.external.bash_script[each.key].result.instance_name
      RecoveryKey         = local.recoverykey
      GatewayName         = format("%s(%s)", local.gatewayname, each.value.regionkey)
      GatewayAdminUserIds = local.gateway_admin_ids
      RegionKey           = each.value.regionkey
    })]))
  })
  depends_on = [module.windows-vm-ss]
}

locals {
  moj_username      = data.azurerm_key_vault_secret.moj_account_username.value
  moj_password      = data.azurerm_key_vault_secret.moj_account_password.value
  moj_tenant_id     = "c6874728-71e6-41fe-a9e1-2e8c36776ad8"
  recoverykey       = data.azurerm_key_vault_secret.power_bi_data_gw_recoverykey.value
  gatewayname       = "Data Gateway"
  gateway_admin_ids = "ca9f7d19-f173-4fd2-ac7e-5f8de7af5113,f77fc581-741c-4d66-a778-38ee8ee2d88d" # testing with Alex, Brendon MOJ object IDs


}


data "external" "bash_script" {
  for_each   = var.vm_scale_sets
  program    = ["bash", "${path.module}/scripts/get_instance_name.bash", local.rg_name, each.key]
  depends_on = [module.windows-vm-ss]
}
# This can output this instance_name     = data.external.bash_script[each.key].instance_name
# kv_name           = azurerm_key_vault.shared-dgw-key-vault.name
# vm_resource_group = local.rg_name

data "azurerm_key_vault_secret" "moj_account_password" {
  name         = "moj-power-bi-password"
  key_vault_id = data.azurerm_key_vault.shared_dgw_kv.id
}
data "azurerm_key_vault_secret" "moj_account_username" {
  name         = "moj-power-bi-username"
  key_vault_id = data.azurerm_key_vault.shared_dgw_kv.id
}

data "azurerm_key_vault_secret" "power_bi_data_gw_recoverykey" {
  name         = "power-bi-data-gw-recoverykey"
  key_vault_id = data.azurerm_key_vault.shared_dgw_kv.id
}
