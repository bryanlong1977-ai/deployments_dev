#------------------------------------------------------------------------------
# Resource Group Outputs
#------------------------------------------------------------------------------

output "storage_resource_group_name" {
  description = "Name of the storage resource group"
  value       = azurerm_resource_group.storage.name
}

output "storage_resource_group_id" {
  description = "ID of the storage resource group"
  value       = azurerm_resource_group.storage.id
}

output "rsv_resource_group_name" {
  description = "Name of the RSV resource group"
  value       = azurerm_resource_group.rsv.name
}

output "rsv_resource_group_id" {
  description = "ID of the RSV resource group"
  value       = azurerm_resource_group.rsv.id
}

#------------------------------------------------------------------------------
# Storage Account Outputs
#------------------------------------------------------------------------------

output "storage_account_vm_id" {
  description = "ID of the VM storage account"
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "Name of the VM storage account"
  value       = azurerm_storage_account.vm.name
}

output "storage_account_vm_primary_blob_endpoint" {
  description = "Primary blob endpoint of the VM storage account"
  value       = azurerm_storage_account.vm.primary_blob_endpoint
}

output "storage_account_vm_primary_access_key" {
  description = "Primary access key of the VM storage account"
  value       = azurerm_storage_account.vm.primary_access_key
  sensitive   = true
}

output "storage_account_network_id" {
  description = "ID of the network storage account"
  value       = azurerm_storage_account.network.id
}

output "storage_account_network_name" {
  description = "Name of the network storage account"
  value       = azurerm_storage_account.network.name
}

output "storage_account_network_primary_blob_endpoint" {
  description = "Primary blob endpoint of the network storage account"
  value       = azurerm_storage_account.network.primary_blob_endpoint
}

output "storage_account_network_primary_access_key" {
  description = "Primary access key of the network storage account"
  value       = azurerm_storage_account.network.primary_access_key
  sensitive   = true
}

#------------------------------------------------------------------------------
# Private Endpoint Outputs
#------------------------------------------------------------------------------

output "pe_storage_vm_blob_id" {
  description = "ID of the VM storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_vm_blob.id
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

output "pe_storage_network_blob_id" {
  description = "ID of the network storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_network_blob.id
}

output "pe_storage_network_file_id" {
  description = "ID of the network storage file private endpoint"
  value       = azurerm_private_endpoint.storage_network_file.id
}

output "pe_storage_network_queue_id" {
  description = "ID of the network storage queue private endpoint"
  value       = azurerm_private_endpoint.storage_network_queue.id
}

output "pe_storage_network_table_id" {
  description = "ID of the network storage table private endpoint"
  value       = azurerm_private_endpoint.storage_network_table.id
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
