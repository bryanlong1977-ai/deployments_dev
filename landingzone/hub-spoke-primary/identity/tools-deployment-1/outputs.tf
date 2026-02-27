# =============================================================================
# Recovery Services Vault Outputs
# =============================================================================

output "recovery_services_vault_id" {
  description = "The ID of the Identity Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.id
}

output "recovery_services_vault_name" {
  description = "The name of the Identity Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.name
}

output "recovery_services_vault_resource_group_name" {
  description = "The resource group name of the Identity Recovery Services Vault."
  value       = azurerm_resource_group.rsv.name
}

# =============================================================================
# Storage Account Outputs - VM Diagnostics
# =============================================================================

output "storage_account_vm_id" {
  description = "The ID of the Identity VM diagnostics storage account."
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "The name of the Identity VM diagnostics storage account."
  value       = azurerm_storage_account.vm.name
}

output "storage_account_vm_primary_blob_endpoint" {
  description = "The primary blob endpoint of the Identity VM diagnostics storage account."
  value       = azurerm_storage_account.vm.primary_blob_endpoint
}

# =============================================================================
# Storage Account Outputs - Network Diagnostics
# =============================================================================

output "storage_account_ntwk_id" {
  description = "The ID of the Identity network diagnostics storage account."
  value       = azurerm_storage_account.ntwk.id
}

output "storage_account_ntwk_name" {
  description = "The name of the Identity network diagnostics storage account."
  value       = azurerm_storage_account.ntwk.name
}

output "storage_account_ntwk_primary_blob_endpoint" {
  description = "The primary blob endpoint of the Identity network diagnostics storage account."
  value       = azurerm_storage_account.ntwk.primary_blob_endpoint
}

# =============================================================================
# Resource Group Outputs
# =============================================================================

output "rsv_resource_group_name" {
  description = "The name of the RSV resource group."
  value       = azurerm_resource_group.rsv.name
}

output "storage_resource_group_name" {
  description = "The name of the storage accounts resource group."
  value       = azurerm_resource_group.storage.name
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
  value       = azurerm_resource_group.rsv.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.rsv.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.rsv.location
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
