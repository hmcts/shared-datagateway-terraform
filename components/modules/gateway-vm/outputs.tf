# Output - vm provisioned
output "ctsc_vm_name" {
  description = "Provisioned CTSC vm name"
  value       = join("", azurerm_windows_virtual_machine.ctsc_vm.*.name)
}

# Output - vm to private ip
output "ctsc_vm_private_ip_address" {
  description = "Provisioned vm private ip"
  value       = join("", azurerm_windows_virtual_machine.ctsc_vm.*.private_ip_address)
}

# Output - vm resource-id
output "ctsc_vm_resource_id" {
  description = "Provisioned vm resource-id"
  value       = join("", azurerm_windows_virtual_machine.ctsc_vm.*.id)
}