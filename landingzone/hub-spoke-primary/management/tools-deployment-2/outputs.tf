#--------------------------------------------------------------
# Automation Account Outputs
#--------------------------------------------------------------
output "automation_account_id" {
  description = "The ID of the Automation Account"
  value       = azurerm_automation_account.this.id
}

output "automation_account_name" {
  description = "The name of the Automation Account"
  value       = azurerm_automation_account.this.name
}

output "automation_account_resource_group_name" {
  description = "The resource group name of the Automation Account"
  value       = azurerm_resource_group.automation_account.name
}

output "automation_account_identity_principal_id" {
  description = "The principal ID of the Automation Account's managed identity"
  value       = azurerm_automation_account.this.identity[0].principal_id
}

output "automation_account_identity_tenant_id" {
  description = "The tenant ID of the Automation Account's managed identity"
  value       = azurerm_automation_account.this.identity[0].tenant_id
}

#--------------------------------------------------------------
# Recovery Services Vault Outputs
#--------------------------------------------------------------
output "recovery_services_vault_id" {
  description = "The ID of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.this.id
}

output "recovery_services_vault_name" {
  description = "The name of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.this.name
}

output "recovery_services_vault_resource_group_name" {
  description = "The resource group name of the Recovery Services Vault"
  value       = azurerm_resource_group.recovery_services_vault.name
}

output "recovery_services_vault_identity_principal_id" {
  description = "The principal ID of the Recovery Services Vault's managed identity"
  value       = azurerm_recovery_services_vault.this.identity[0].principal_id
}

output "recovery_services_vault_identity_tenant_id" {
  description = "The tenant ID of the Recovery Services Vault's managed identity"
  value       = azurerm_recovery_services_vault.this.identity[0].tenant_id
}

#--------------------------------------------------------------
# Storage Account Outputs - VM Diagnostics
#--------------------------------------------------------------
output "storage_account_vm_id" {
  description = "The ID of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "The name of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.name
}

output "storage_account_vm_primary_blob_endpoint" {
  description = "The primary blob endpoint for the VM storage account"
  value       = azurerm_storage_account.vm.primary_blob_endpoint
}

output "storage_account_vm_primary_access_key" {
  description = "The primary access key for the VM storage account"
  value       = azurerm_storage_account.vm.primary_access_key
  sensitive   = true
}

#--------------------------------------------------------------
# Storage Account Outputs - Network Diagnostics
#--------------------------------------------------------------
output "storage_account_ntwk_id" {
  description = "The ID of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.id
}

output "storage_account_ntwk_name" {
  description = "The name of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.name
}

output "storage_account_ntwk_primary_blob_endpoint" {
  description = "The primary blob endpoint for the network storage account"
  value       = azurerm_storage_account.ntwk.primary_blob_endpoint
}

output "storage_account_ntwk_primary_access_key" {
  description = "The primary access key for the network storage account"
  value       = azurerm_storage_account.ntwk.primary_access_key
  sensitive   = true
}

#--------------------------------------------------------------
# Storage Resource Group Output
#--------------------------------------------------------------
output "storage_resource_group_name" {
  description = "The resource group name for storage accounts"
  value       = azurerm_resource_group.storage.name
}

output "storage_resource_group_id" {
  description = "The resource group ID for storage accounts"
  value       = azurerm_resource_group.storage.id
}

#--------------------------------------------------------------
# Private Endpoint Outputs
#--------------------------------------------------------------
output "automation_account_pe_webhook_id" {
  description = "The ID of the Automation Account Webhook private endpoint"
  value       = azurerm_private_endpoint.automation_webhook.id
}

output "automation_account_pe_dsc_id" {
  description = "The ID of the Automation Account DSC private endpoint"
  value       = azurerm_private_endpoint.automation_dsc.id
}

output "recovery_services_vault_pe_backup_id" {
  description = "The ID of the Recovery Services Vault Backup private endpoint"
  value       = azurerm_private_endpoint.rsv_backup.id
}

output "recovery_services_vault_pe_siterecovery_id" {
  description = "The ID of the Recovery Services Vault Site Recovery private endpoint"
  value       = azurerm_private_endpoint.rsv_siterecovery.id
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
