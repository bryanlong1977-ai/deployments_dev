#------------------------------------------------------------------------------
# Resource Group Outputs
#------------------------------------------------------------------------------

output "rsv_resource_group_name" {
  description = "Name of the Recovery Services Vault resource group"
  value       = azurerm_resource_group.rsv.name
}

output "rsv_resource_group_id" {
  description = "ID of the Recovery Services Vault resource group"
  value       = azurerm_resource_group.rsv.id
}

output "storage_resource_group_name" {
  description = "Name of the Storage Accounts resource group"
  value       = azurerm_resource_group.storage.name
}

output "storage_resource_group_id" {
  description = "ID of the Storage Accounts resource group"
  value       = azurerm_resource_group.storage.id
}

#------------------------------------------------------------------------------
# Recovery Services Vault Outputs
#------------------------------------------------------------------------------

output "recovery_services_vault_id" {
  description = "ID of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.rsv.id
}

output "recovery_services_vault_name" {
  description = "Name of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.rsv.name
}

output "recovery_services_vault_identity_principal_id" {
  description = "Principal ID of the Recovery Services Vault managed identity"
  value       = azurerm_recovery_services_vault.rsv.identity[0].principal_id
}

output "recovery_services_vault_identity_tenant_id" {
  description = "Tenant ID of the Recovery Services Vault managed identity"
  value       = azurerm_recovery_services_vault.rsv.identity[0].tenant_id
}

#------------------------------------------------------------------------------
# Storage Account Outputs - VM Diagnostics
#------------------------------------------------------------------------------

output "storage_account_vm_id" {
  description = "ID of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "Name of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.name
}

output "storage_account_vm_primary_blob_endpoint" {
  description = "Primary blob endpoint of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.primary_blob_endpoint
}

output "storage_account_vm_primary_access_key" {
  description = "Primary access key of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.primary_access_key
  sensitive   = true
}

#------------------------------------------------------------------------------
# Storage Account Outputs - Network Diagnostics
#------------------------------------------------------------------------------

output "storage_account_ntwk_id" {
  description = "ID of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.id
}

output "storage_account_ntwk_name" {
  description = "Name of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.name
}

output "storage_account_ntwk_primary_blob_endpoint" {
  description = "Primary blob endpoint of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.primary_blob_endpoint
}

output "storage_account_ntwk_primary_access_key" {
  description = "Primary access key of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.primary_access_key
  sensitive   = true
}

#------------------------------------------------------------------------------
# Private Endpoint Outputs
#------------------------------------------------------------------------------

output "rsv_backup_private_endpoint_id" {
  description = "ID of the RSV Azure Backup private endpoint"
  value       = azurerm_private_endpoint.rsv_backup.id
}

output "rsv_siterecovery_private_endpoint_id" {
  description = "ID of the RSV Site Recovery private endpoint"
  value       = azurerm_private_endpoint.rsv_siterecovery.id
}

output "storage_vm_blob_private_endpoint_id" {
  description = "ID of the VM storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_vm_blob.id
}

output "storage_ntwk_blob_private_endpoint_id" {
  description = "ID of the network storage blob private endpoint"
  value       = azurerm_private_endpoint.storage_ntwk_blob.id
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
