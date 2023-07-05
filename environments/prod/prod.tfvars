subnet_prefix       = "10.11.8.224/28"
hub_subscription_id = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
environment         = "prod"
infra_hub_suffix    = "prod-int"
buildEnv            = "prod"
vm_zones = [
  {
    vm_count = 0,
    vm_zone  = 1
  },
  {
    vm_count = 1,
    vm_zone  = 2
  }
]

# Splunk
install_splunk_uf = true
cnp_vault_rg      = "cnp-core-infra"
cnp_vault_sub     = "1c4f0704-a29e-403d-b719-b90c34ef14c9"

# Nessus
nessus_install  = true
nessus_server   = "nessus-scanners-prod000005.platform.hmcts.net"
nessus_groups   = "Prod-test"
nessus_key_name = "nessus-agent-key-prod"

# Dynatrace for prod
dynatrace_tenant_id = "ebe20728"
dynatrace_server    = "https://10.10.70.30:9999/e/ebe20728/api"

# VM SKU
vm_publisher_name       = "MicrosoftWindowsServer"
vm_publisher            = "center-for-internet-security-inc"
vm_offer                = "cis-windows-server-2022-l2"
vm_sku                  = "cis-windows-server-2022-l2-gen2"
vm_version              = "latest"
vm_size                 = "Standard_D8ds_v5"
vm_storage_account_type = "StandardSSD_LRS"

# Automation acount
automation_account_name      = "shared-dgw-prod-automation"
log_analytics_workspace_name = "shared-dgw-prod-workspace"
sku_name_workspace           = "PerGB2018"
log_retention_days           = 30
sku_name                     = "Basic"
