# Output - vm provisioned
output "shared_dgw_vm_name" {
  description = "Provisioned CTSC vm name"
  value       = toset([for vm in azurerm_windows_virtual_machine.shared_dgw_vm : vm.name])
}

# Output - vm to private ip
output "shared_dgw_vm_private_ip_address" {
  description = "Provisioned vm private ip"
  value       = toset([for vm in azurerm_windows_virtual_machine.shared_dgw_vm : vm.private_ip_address])
}

# Output - vm resource-id
output "shared_dgw_vm_resource_id" {
  description = "Provisioned vm resource-id"
  value       = toset([for vm in azurerm_windows_virtual_machine.shared_dgw_vm : vm.id])
}