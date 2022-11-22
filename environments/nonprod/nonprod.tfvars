subnet_prefix       = "10.11.72.192/28"
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
vm_size                 = "Standard_D8s_v3"
vm_storage_account_type = "StandardSSD_LRS"