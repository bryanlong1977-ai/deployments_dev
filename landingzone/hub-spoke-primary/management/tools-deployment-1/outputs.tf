# ============================================
# Log Analytics Workspace Outputs
# ============================================
output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.name
}

output "log_analytics_workspace_guid" {
  description = "Workspace GUID (UUID) of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "log_analytics_workspace_primary_shared_key" {
  description = "Primary shared key of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_resource_group_name" {
  description = "Resource group name of the Log Analytics Workspace"
  value       = azurerm_resource_group.log.name
}

# ============================================
# Automation Account Outputs
# ============================================
output "automation_account_id" {
  description = "Resource ID of the Automation Account"
  value       = azurerm_automation_account.this.id
}

output "automation_account_name" {
  description = "Name of the Automation Account"
  value       = azurerm_automation_account.this.name
}

output "automation_account_resource_group_name" {
  description = "Resource group name of the Automation Account"
  value       = azurerm_resource_group.aa.name
}

output "automation_account_identity_principal_id" {
  description = "Principal ID of the Automation Account system-assigned managed identity"
  value       = azurerm_automation_account.this.identity[0].principal_id
}

# ============================================
# Key Vault Outputs
# ============================================
output "key_vault_prd_id" {
  description = "Resource ID of the production Key Vault"
  value       = azurerm_key_vault.prd.id
}

output "key_vault_prd_name" {
  description = "Name of the production Key Vault"
  value       = azurerm_key_vault.prd.name
}

output "key_vault_prd_uri" {
  description = "URI of the production Key Vault"
  value       = azurerm_key_vault.prd.vault_uri
}

output "key_vault_nprd_id" {
  description = "Resource ID of the non-production Key Vault"
  value       = azurerm_key_vault.nprd.id
}

output "key_vault_nprd_name" {
  description = "Name of the non-production Key Vault"
  value       = azurerm_key_vault.nprd.name
}

output "key_vault_nprd_uri" {
  description = "URI of the non-production Key Vault"
  value       = azurerm_key_vault.nprd.vault_uri
}

output "key_vault_resource_group_name" {
  description = "Resource group name for the Key Vaults"
  value       = azurerm_resource_group.kv.name
}

# ============================================
# Managed Identity Outputs
# ============================================
output "managed_identity_id" {
  description = "Resource ID of the managed identity"
  value       = azurerm_user_assigned_identity.this.id
}

output "managed_identity_name" {
  description = "Name of the managed identity"
  value       = azurerm_user_assigned_identity.this.name
}

output "managed_identity_principal_id" {
  description = "Principal ID of the managed identity"
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "managed_identity_client_id" {
  description = "Client ID of the managed identity"
  value       = azurerm_user_assigned_identity.this.client_id
}

output "managed_identity_resource_group_name" {
  description = "Resource group name of the managed identity"
  value       = azurerm_resource_group.mi.name
}

# ============================================
# Storage Account Outputs
# ============================================
output "storage_account_diag_id" {
  description = "Resource ID of the diagnostics storage account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_diag_name" {
  description = "Name of the diagnostics storage account"
  value       = azurerm_storage_account.this.name
}

output "storage_account_diag_primary_blob_endpoint" {
  description = "Primary blob endpoint of the diagnostics storage account"
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "storage_account_diag_resource_group_name" {
  description = "Resource group name of the diagnostics storage account"
  value       = azurerm_resource_group.st.name
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
  value       = azurerm_resource_group.log.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.log.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.log.location
}

output "log_analytics_workspace_resource_id" {
  description = "Alias for log_analytics_workspace_id"
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_primary_shared_key" {
  description = "Primary shared key for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

output "key_vault_id" {
  description = "The resource ID of the Key Vault"
  value       = azurerm_key_vault.prd.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.prd.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.prd.vault_uri
}

output "storage_account_id" {
  description = "The resource ID of the Storage Account"
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.this.name
}

output "storage_account_resource_group_name" {
  description = "The resource group that contains the Storage Account"
  value       = azurerm_storage_account.this.resource_group_name
}
