# Storage Account Outputs
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

# Resource Group Outputs
output "storage_resource_group_name" {
  description = "Name of the storage resource group"
  value       = azurerm_resource_group.storage.name
}

output "storage_resource_group_id" {
  description = "ID of the storage resource group"
  value       = azurerm_resource_group.storage.id
}

output "rsv_resource_group_name" {
  description = "Name of the recovery services vault resource group"
  value       = azurerm_resource_group.rsv.name
}

output "rsv_resource_group_id" {
  description = "ID of the recovery services vault resource group"
  value       = azurerm_resource_group.rsv.id
}

# Recovery Services Vault Outputs
output "recovery_services_vault_id" {
  description = "ID of the recovery services vault"
  value       = azurerm_recovery_services_vault.dmz.id
}

output "recovery_services_vault_name" {
  description = "Name of the recovery services vault"
  value       = azurerm_recovery_services_vault.dmz.name
}

output "recovery_services_vault_identity_principal_id" {
  description = "Principal ID of the recovery services vault managed identity"
  value       = azurerm_recovery_services_vault.dmz.identity[0].principal_id
}

# Private Endpoint Outputs
output "storage_vm_blob_private_endpoint_id" {
  description = "ID of the VM storage account blob private endpoint"
  value       = azurerm_private_endpoint.storage_vm_blob.id
}

output "storage_network_blob_private_endpoint_id" {
  description = "ID of the network storage account blob private endpoint"
  value       = azurerm_private_endpoint.storage_network_blob.id
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
