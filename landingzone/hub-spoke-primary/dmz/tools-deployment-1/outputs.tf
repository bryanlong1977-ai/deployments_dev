# Storage Resource Group Outputs
output "storage_resource_group_name" {
  description = "Name of the storage resource group"
  value       = azurerm_resource_group.storage.name
}

output "storage_resource_group_id" {
  description = "ID of the storage resource group"
  value       = azurerm_resource_group.storage.id
}

output "storage_resource_group_location" {
  description = "Location of the storage resource group"
  value       = azurerm_resource_group.storage.location
}

# RSV Resource Group Outputs
output "rsv_resource_group_name" {
  description = "Name of the RSV resource group"
  value       = azurerm_resource_group.rsv.name
}

output "rsv_resource_group_id" {
  description = "ID of the RSV resource group"
  value       = azurerm_resource_group.rsv.id
}

# Storage Account Outputs - VM
output "storage_account_vm_id" {
  description = "ID of the VM storage account"
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "Name of the VM storage account"
  value       = azurerm_storage_account.vm.name
}

output "storage_account_vm_primary_blob_endpoint" {
  description = "Primary blob endpoint for VM storage account"
  value       = azurerm_storage_account.vm.primary_blob_endpoint
}

output "storage_account_vm_primary_access_key" {
  description = "Primary access key for VM storage account"
  value       = azurerm_storage_account.vm.primary_access_key
  sensitive   = true
}

# Storage Account Outputs - Net
output "storage_account_net_id" {
  description = "ID of the network storage account"
  value       = azurerm_storage_account.net.id
}

output "storage_account_net_name" {
  description = "Name of the network storage account"
  value       = azurerm_storage_account.net.name
}

output "storage_account_net_primary_blob_endpoint" {
  description = "Primary blob endpoint for network storage account"
  value       = azurerm_storage_account.net.primary_blob_endpoint
}

output "storage_account_net_primary_access_key" {
  description = "Primary access key for network storage account"
  value       = azurerm_storage_account.net.primary_access_key
  sensitive   = true
}

# Private Endpoint Outputs - VM Storage
output "pe_storage_vm_blob_id" {
  description = "ID of the VM storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_vm_blob.id
}

output "pe_storage_vm_blob_private_ip" {
  description = "Private IP of the VM storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_vm_blob.private_service_connection[0].private_ip_address
}

output "pe_storage_vm_file_id" {
  description = "ID of the VM storage file private endpoint"
  value       = azurerm_private_endpoint.storage_vm_file.id
}

output "pe_storage_vm_queue_id" {
  description = "ID of the VM storage queue private endpoint"
  value       = azurerm_private_endpoint.storage_vm_queue.id
}

output "pe_storage_vm_table_id" {
  description = "ID of the VM storage table private endpoint"
  value       = azurerm_private_endpoint.storage_vm_table.id
}

# Private Endpoint Outputs - Net Storage
output "pe_storage_net_blob_id" {
  description = "ID of the network storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_net_blob.id
}

output "pe_storage_net_blob_private_ip" {
  description = "Private IP of the network storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_net_blob.private_service_connection[0].private_ip_address
}

output "pe_storage_net_file_id" {
  description = "ID of the network storage file private endpoint"
  value       = azurerm_private_endpoint.storage_net_file.id
}

output "pe_storage_net_queue_id" {
  description = "ID of the network storage queue private endpoint"
  value       = azurerm_private_endpoint.storage_net_queue.id
}

output "pe_storage_net_table_id" {
  description = "ID of the network storage table private endpoint"
  value       = azurerm_private_endpoint.storage_net_table.id
}

# ============================================
# Standard Outputs (auto-generated for cross-deployment compatibility)
# These outputs are required by downstream deployments via terraform_remote_state
# ============================================

output "vnet_id" {
  description = "The ID of the deployed Virtual Network"
  value       = null  # TODO: Set to the correct resource reference
}

output "vnet_name" {
  description = "The name of the deployed Virtual Network"
  value       = null  # TODO: Set to the correct resource reference
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.storage.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.storage.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.storage.location
}
