subnet_prefix       = "10.11.72.208/28"
hub_subscription_id = "fb084706-583f-4c9a-bdab-949aac66ba5c"
environment         = "nonprod"
infra_hub_suffix    = "nonprodi"
buildEnv            = "stg"
vm_zones = [
  {
    vm_count = 1,
    vm_zone  = 1
  }
]

# Splunk
install_splunk_uf = true
cnp_vault_rg      = "cnp-core-infra"
cnp_vault_sub     = "1c4f0704-a29e-403d-b719-b90c34ef14c9"

# Nessus
nessus_install  = true
nessus_server   = "nessus-scanners-nonprod000005.platform.hmcts.net"
nessus_groups   = "Nonprod-test"
nessus_key_name = "nessus-agent-key-nonprod"

# VM SKU
vm_publisher_name       = "MicrosoftWindowsServer"
vm_publisher            = "center-for-internet-security-inc"
vm_offer                = "cis-windows-server-2022-l2"
vm_sku                  = "cis-windows-server-2022-l2-gen2"
vm_version              = "latest"
vm_size                 = "Standard_D8ds_v5"
vm_storage_account_type = "StandardSSD_LRS"

# Automation acount
automation_account_name      = "shared-dgw-automation"
log_analytics_workspace_name = "shared-dgw-workspace"
sku_name_workspace           = "PerGB2018"
log_retention_days           = 30
sku_name                     = "Basic"

# Dynatrace for non-prod
dynatrace_tenant_id = "yrk32651"
dynatrace_server    = "https://10.10.70.8:9999/e/yrk32651/api"

# VM Scale-Sets

vm_scale_sets = {
  data-gw-vmss-nonprod-uksouth = {
    regionkey            = "uksouth"
    vm_sku               = "Standard_D8ds_v5"
    vm_availabilty_zones = ["1"]
    vm_instances         = 2
    network_interfaces = {
      nic0 = { name = "data-gw-vmss-nonprod-uksouth-nic",
        primary        = true,
        ip_config_name = "data-gw-vmss-nonprod-uksouth-ipconfig",
      }
    }
    managed_disks = {
      datadisk01 = {
        storage_account_type = "Standard_LRS"
        disk_create_option   = "Empty"
        disk_size_gb         = "128"
        disk_lun             = "10"
        disk_caching         = "ReadWrite"
      }
    }
  },

  data-gw-vmss-nonprod-northeu = {
    regionkey            = "northeurope"
    vm_sku               = "Standard_D8ds_v5"
    vm_availabilty_zones = ["1"]
    vm_instances         = 2
    network_interfaces = {
      nic0 = { name = "data-gw-vmss-nonprod-northeu-nic",
        primary        = true,
        ip_config_name = "data-gw-vmss-nonprod-northeu-ipconfig",
      }
    }
    managed_disks = {
      datadisk01 = {
        storage_account_type = "Standard_LRS"
        disk_create_option   = "Empty"
        disk_size_gb         = "128"
        disk_lun             = "10"
        disk_caching         = "ReadWrite"
      }
    }
  }

}
