# =============================================================================
# Outputs for Connectivity Tools Deployment 1
# =============================================================================

# AMPLS Outputs
output "ampls_id" {
  description = "The ID of the Azure Monitor Private Link Scope."
  value       = azurerm_monitor_private_link_scope.this.id
}

output "ampls_name" {
  description = "The name of the Azure Monitor Private Link Scope."
  value       = azurerm_monitor_private_link_scope.this.name
}

output "ampls_resource_group_name" {
  description = "The resource group name of the Azure Monitor Private Link Scope."
  value       = azurerm_resource_group.ampls.name
}

output "ampls_private_endpoint_id" {
  description = "The ID of the AMPLS private endpoint."
  value       = azurerm_private_endpoint.ampls.id
}

# Storage Account - VM Outputs
output "storage_account_vm_id" {
  description = "The ID of the VM diagnostics storage account."
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "The name of the VM diagnostics storage account."
  value       = azurerm_storage_account.vm.name
}

output "storage_account_vm_primary_blob_endpoint" {
  description = "The primary blob endpoint of the VM diagnostics storage account."
  value       = azurerm_storage_account.vm.primary_blob_endpoint
}

# Storage Account - Network Outputs
output "storage_account_ntwk_id" {
  description = "The ID of the network diagnostics storage account."
  value       = azurerm_storage_account.ntwk.id
}

output "storage_account_ntwk_name" {
  description = "The name of the network diagnostics storage account."
  value       = azurerm_storage_account.ntwk.name
}

output "storage_account_ntwk_primary_blob_endpoint" {
  description = "The primary blob endpoint of the network diagnostics storage account."
  value       = azurerm_storage_account.ntwk.primary_blob_endpoint
}

# Resource Group Outputs
output "storage_resource_group_name" {
  description = "The name of the storage accounts resource group."
  value       = azurerm_resource_group.storage.name
}

output "ampls_resource_group_id" {
  description = "The ID of the AMPLS resource group."
  value       = azurerm_resource_group.ampls.id
}

output "storage_resource_group_id" {
  description = "The ID of the storage accounts resource group."
  value       = azurerm_resource_group.storage.id
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

output "storage_account_id" {
  description = "The resource ID of the Storage Account"
  value       = azurerm_storage_account.vm.id
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.vm.name
}

output "storage_account_resource_group_name" {
  description = "The resource group that contains the Storage Account"
  value       = azurerm_storage_account.vm.resource_group_name
}
