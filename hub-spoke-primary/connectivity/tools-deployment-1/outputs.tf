# =============================================================================
# Resource Group Outputs
# =============================================================================

output "ampls_resource_group_name" {
  description = "The name of the Azure Monitor Private Link Scope resource group"
  value       = azurerm_resource_group.ampls.name
}

output "ampls_resource_group_id" {
  description = "The ID of the Azure Monitor Private Link Scope resource group"
  value       = azurerm_resource_group.ampls.id
}

output "storage_resource_group_name" {
  description = "The name of the Storage Accounts resource group"
  value       = azurerm_resource_group.storage.name
}

output "storage_resource_group_id" {
  description = "The ID of the Storage Accounts resource group"
  value       = azurerm_resource_group.storage.id
}

# =============================================================================
# Azure Monitor Private Link Scope Outputs
# =============================================================================

output "ampls_id" {
  description = "The ID of the Azure Monitor Private Link Scope"
  value       = azurerm_monitor_private_link_scope.ampls.id
}

output "ampls_name" {
  description = "The name of the Azure Monitor Private Link Scope"
  value       = azurerm_monitor_private_link_scope.ampls.name
}

output "ampls_private_endpoint_id" {
  description = "The ID of the AMPLS private endpoint"
  value       = azurerm_private_endpoint.ampls.id
}

output "ampls_private_endpoint_ip" {
  description = "The private IP address of the AMPLS private endpoint"
  value       = azurerm_private_endpoint.ampls.private_service_connection[0].private_ip_address
}

# =============================================================================
# Storage Account Outputs
# =============================================================================

output "storage_account_vm_id" {
  description = "The ID of the VM storage account"
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "The name of the VM storage account"
  value       = azurerm_storage_account.vm.name
}

output "storage_account_vm_primary_blob_endpoint" {
  description = "The primary blob endpoint of the VM storage account"
  value       = azurerm_storage_account.vm.primary_blob_endpoint
}

output "storage_account_ntwk_id" {
  description = "The ID of the network storage account"
  value       = azurerm_storage_account.ntwk.id
}

output "storage_account_ntwk_name" {
  description = "The name of the network storage account"
  value       = azurerm_storage_account.ntwk.name
}

output "storage_account_ntwk_primary_blob_endpoint" {
  description = "The primary blob endpoint of the network storage account"
  value       = azurerm_storage_account.ntwk.primary_blob_endpoint
}

# =============================================================================
# Private Endpoint Outputs
# =============================================================================

output "storage_vm_blob_private_endpoint_id" {
  description = "The ID of the VM storage account blob private endpoint"
  value       = azurerm_private_endpoint.vm_blob.id
}

output "storage_vm_file_private_endpoint_id" {
  description = "The ID of the VM storage account file private endpoint"
  value       = azurerm_private_endpoint.vm_file.id
}

output "storage_vm_queue_private_endpoint_id" {
  description = "The ID of the VM storage account queue private endpoint"
  value       = azurerm_private_endpoint.vm_queue.id
}

output "storage_vm_table_private_endpoint_id" {
  description = "The ID of the VM storage account table private endpoint"
  value       = azurerm_private_endpoint.vm_table.id
}

output "storage_ntwk_blob_private_endpoint_id" {
  description = "The ID of the network storage account blob private endpoint"
  value       = azurerm_private_endpoint.ntwk_blob.id
}

output "storage_ntwk_file_private_endpoint_id" {
  description = "The ID of the network storage account file private endpoint"
  value       = azurerm_private_endpoint.ntwk_file.id
}

output "storage_ntwk_queue_private_endpoint_id" {
  description = "The ID of the network storage account queue private endpoint"
  value       = azurerm_private_endpoint.ntwk_queue.id
}

output "storage_ntwk_table_private_endpoint_id" {
  description = "The ID of the network storage account table private endpoint"
  value       = azurerm_private_endpoint.ntwk_table.id
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
  value       = azurerm_resource_group.ampls.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.ampls.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.ampls.location
}

output "hub_vnet_id" {
  description = "The ID of the hub Virtual Network (alias for vnet_id)"
  value       = null  # TODO: Set to the correct resource reference
}

output "hub_vnet_name" {
  description = "The name of the hub Virtual Network (alias for vnet_name)"
  value       = null  # TODO: Set to the correct resource reference
}

output "hub_resource_group_name" {
  description = "The name of the hub resource group (alias for resource_group_name)"
  value       = azurerm_resource_group.ampls.name
}
