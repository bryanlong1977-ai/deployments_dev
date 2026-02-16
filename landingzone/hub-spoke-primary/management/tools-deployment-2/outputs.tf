# Automation Account Outputs
output "automation_account_id" {
  description = "The ID of the Automation Account"
  value       = azurerm_automation_account.main.id
}

output "automation_account_name" {
  description = "The name of the Automation Account"
  value       = azurerm_automation_account.main.name
}

output "automation_account_resource_group_name" {
  description = "The resource group name of the Automation Account"
  value       = azurerm_resource_group.automation_account.name
}

output "automation_account_identity_principal_id" {
  description = "The principal ID of the Automation Account managed identity"
  value       = azurerm_automation_account.main.identity[0].principal_id
}

output "automation_account_identity_tenant_id" {
  description = "The tenant ID of the Automation Account managed identity"
  value       = azurerm_automation_account.main.identity[0].tenant_id
}

output "automation_account_private_endpoint_id" {
  description = "The ID of the Automation Account private endpoint"
  value       = azurerm_private_endpoint.automation_account.id
}

# Recovery Services Vault Outputs
output "recovery_services_vault_id" {
  description = "The ID of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.main.id
}

output "recovery_services_vault_name" {
  description = "The name of the Recovery Services Vault"
  value       = azurerm_recovery_services_vault.main.name
}

output "recovery_services_vault_resource_group_name" {
  description = "The resource group name of the Recovery Services Vault"
  value       = azurerm_resource_group.recovery_services_vault.name
}

output "recovery_services_vault_identity_principal_id" {
  description = "The principal ID of the Recovery Services Vault managed identity"
  value       = azurerm_recovery_services_vault.main.identity[0].principal_id
}

output "recovery_services_vault_identity_tenant_id" {
  description = "The tenant ID of the Recovery Services Vault managed identity"
  value       = azurerm_recovery_services_vault.main.identity[0].tenant_id
}

output "recovery_services_vault_private_endpoint_id" {
  description = "The ID of the Recovery Services Vault private endpoint"
  value       = azurerm_private_endpoint.recovery_services_vault.id
}

# Storage Account VM Outputs
output "storage_account_vm_id" {
  description = "The ID of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.id
}

output "storage_account_vm_name" {
  description = "The name of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.name
}

output "storage_account_vm_primary_blob_endpoint" {
  description = "The primary blob endpoint of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.primary_blob_endpoint
}

output "storage_account_vm_primary_access_key" {
  description = "The primary access key of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm.primary_access_key
  sensitive   = true
}

# Storage Account Network Outputs
output "storage_account_ntwk_id" {
  description = "The ID of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.id
}

output "storage_account_ntwk_name" {
  description = "The name of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.name
}

output "storage_account_ntwk_primary_blob_endpoint" {
  description = "The primary blob endpoint of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.primary_blob_endpoint
}

output "storage_account_ntwk_primary_access_key" {
  description = "The primary access key of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk.primary_access_key
  sensitive   = true
}

# Storage Resource Group Output
output "storage_resource_group_name" {
  description = "The name of the storage accounts resource group"
  value       = azurerm_resource_group.storage.name
}

# Private Endpoint IDs
output "storage_vm_private_endpoint_ids" {
  description = "Map of private endpoint IDs for VM storage account"
  value = {
    blob  = azurerm_private_endpoint.storage_vm_blob.id
    file  = azurerm_private_endpoint.storage_vm_file.id
    queue = azurerm_private_endpoint.storage_vm_queue.id
    table = azurerm_private_endpoint.storage_vm_table.id
  }
}

output "storage_ntwk_private_endpoint_ids" {
  description = "Map of private endpoint IDs for network storage account"
  value = {
    blob  = azurerm_private_endpoint.storage_ntwk_blob.id
    file  = azurerm_private_endpoint.storage_ntwk_file.id
    queue = azurerm_private_endpoint.storage_ntwk_queue.id
    table = azurerm_private_endpoint.storage_ntwk_table.id
  }
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
