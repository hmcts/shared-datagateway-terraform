data "azurerm_resource_group" "ctsc_rg" {
}
module "automation-account" {
  source = "git@github.com:hmcts/oracle-azure-infrastructure-terraform-modules.git//azure-auto?ref=DTSPO-9971-add-tag-field-to-modules"

  resource_group_name          = ctsc_rg.resource_group_name
  automation_account_name      = "ctsc-dgw-automation"
  log_analytics_workspace_name = "ctsc-dgw-workspace"
  sku_name_workspace           = "PerGB2018"
  log_retention_days           = "30"

  tags = merge(local.common_tags, local.extra_tags, local.enforced_tags)
}