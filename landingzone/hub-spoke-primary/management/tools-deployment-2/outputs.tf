# ============================================
# Automation Account Outputs
# ============================================

output "automation_account_id" {
  description = "The ID of the Automation Account."
  value       = azurerm_automation_account.this.id
}

output "automation_account_name" {
  description = "The name of the Automation Account."
  value       = azurerm_automation_account.this.name
}

output "automation_account_resource_group_name" {
  description = "The resource group name of the Automation Account."
  value       = azurerm_resource_group.automation_account.name
}

output "automation_account_identity_principal_id" {
  description = "The principal ID of the Automation Account system-assigned identity."
  value       = azurerm_automation_account.this.identity[0].principal_id
}

# ============================================
# Recovery Services Vault Outputs
# ============================================

output "recovery_services_vault_id" {
  description = "The ID of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.id
}

output "recovery_services_vault_name" {
  description = "The name of the Recovery Services Vault."
  value       = azurerm_recovery_services_vault.this.name
}

output "recovery_services_vault_resource_group_name" {
  description = "The resource group name of the Recovery Services Vault."
  value       = azurerm_resource_group.recovery_services_vault.name
}

output "recovery_services_vault_identity_principal_id" {
  description = "The principal ID of the Recovery Services Vault system-assigned identity."
  value       = azurerm_recovery_services_vault.this.identity[0].principal_id
}

# ============================================
# Storage Account Outputs
# ============================================

output "storage_account_vm_id" {
  description = "The ID of the VM storage account."
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "The name of the VM storage account."
  value       = azurerm_storage_account.vm.name
}

output "storage_account_ntwk_id" {
  description = "The ID of the network storage account."
  value       = azurerm_storage_account.ntwk.id
}

output "storage_account_ntwk_name" {
  description = "The name of the network storage account."
  value       = azurerm_storage_account.ntwk.name
}

output "storage_account_resource_group_name" {
  description = "The resource group name for the storage accounts."
  value       = azurerm_resource_group.storage_account.name
}

# ============================================
# Private Endpoint Outputs
# ============================================

output "pe_storage_vm_blob_id" {
  description = "The ID of the VM storage account blob private endpoint."
  value       = azurerm_private_endpoint.storage_vm_blob.id
}

output "pe_storage_ntwk_blob_id" {
  description = "The ID of the network storage account blob private endpoint."
  value       = azurerm_private_endpoint.storage_ntwk_blob.id
}

output "pe_automation_account_id" {
  description = "The ID of the Automation Account private endpoint."
  value       = azurerm_private_endpoint.automation_account.id
}

output "pe_recovery_services_vault_id" {
  description = "The ID of the Recovery Services Vault private endpoint."
  value       = azurerm_private_endpoint.recovery_services_vault.id
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
  value       = azurerm_resource_group.automation_account.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.automation_account.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.automation_account.location
}

output "storage_account_id" {
  description = "The resource ID of the Storage Account"
  value       = azurerm_storage_account.vm.id
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.vm.name
}
