# ============================================
# Log Analytics Workspace Outputs
# ============================================

output "log_analytics_workspace_id" {
  description = "The full Azure resource ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_guid" {
  description = "The workspace GUID (UUID) of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

output "log_analytics_workspace_resource_group_name" {
  description = "The resource group name of the Log Analytics Workspace."
  value       = azurerm_resource_group.log_analytics.name
}

output "log_analytics_workspace_primary_shared_key" {
  description = "The primary shared key of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

# ============================================
# Key Vault Outputs
# ============================================

output "key_vault_prd_id" {
  description = "The resource ID of the production Key Vault."
  value       = azurerm_key_vault.prd.id
}

output "key_vault_prd_name" {
  description = "The name of the production Key Vault."
  value       = azurerm_key_vault.prd.name
}

output "key_vault_prd_uri" {
  description = "The URI of the production Key Vault."
  value       = azurerm_key_vault.prd.vault_uri
}

output "key_vault_prd_resource_group_name" {
  description = "The resource group name of the production Key Vault."
  value       = azurerm_resource_group.key_vault.name
}

output "key_vault_nprd_id" {
  description = "The resource ID of the non-production Key Vault."
  value       = azurerm_key_vault.nprd.id
}

output "key_vault_nprd_name" {
  description = "The name of the non-production Key Vault."
  value       = azurerm_key_vault.nprd.name
}

output "key_vault_nprd_uri" {
  description = "The URI of the non-production Key Vault."
  value       = azurerm_key_vault.nprd.vault_uri
}

# ============================================
# Key Vault Private Endpoint Outputs
# ============================================

output "key_vault_prd_private_endpoint_id" {
  description = "The resource ID of the production Key Vault private endpoint."
  value       = azurerm_private_endpoint.kv_prd.id
}

output "key_vault_prd_private_ip_address" {
  description = "The private IP address of the production Key Vault private endpoint."
  value       = azurerm_private_endpoint.kv_prd.private_service_connection[0].private_ip_address
}

output "key_vault_nprd_private_endpoint_id" {
  description = "The resource ID of the non-production Key Vault private endpoint."
  value       = azurerm_private_endpoint.kv_nprd.id
}

output "key_vault_nprd_private_ip_address" {
  description = "The private IP address of the non-production Key Vault private endpoint."
  value       = azurerm_private_endpoint.kv_nprd.private_service_connection[0].private_ip_address
}

# ============================================
# Managed Identity Outputs
# ============================================

output "managed_identity_id" {
  description = "The resource ID of the User Assigned Managed Identity."
  value       = azurerm_user_assigned_identity.this.id
}

output "managed_identity_name" {
  description = "The name of the User Assigned Managed Identity."
  value       = azurerm_user_assigned_identity.this.name
}

output "managed_identity_principal_id" {
  description = "The principal ID (object ID) of the User Assigned Managed Identity."
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "managed_identity_client_id" {
  description = "The client ID of the User Assigned Managed Identity."
  value       = azurerm_user_assigned_identity.this.client_id
}

output "managed_identity_tenant_id" {
  description = "The tenant ID of the User Assigned Managed Identity."
  value       = azurerm_user_assigned_identity.this.tenant_id
}

output "managed_identity_resource_group_name" {
  description = "The resource group name of the Managed Identity."
  value       = azurerm_resource_group.managed_identity.name
}

# ============================================
# Resource Group Outputs
# ============================================

output "key_vault_resource_group_name" {
  description = "The name of the Key Vault resource group."
  value       = azurerm_resource_group.key_vault.name
}

output "key_vault_resource_group_id" {
  description = "The ID of the Key Vault resource group."
  value       = azurerm_resource_group.key_vault.id
}

output "log_analytics_resource_group_id" {
  description = "The ID of the Log Analytics resource group."
  value       = azurerm_resource_group.log_analytics.id
}

output "managed_identity_resource_group_id" {
  description = "The ID of the Managed Identity resource group."
  value       = azurerm_resource_group.managed_identity.id
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
  value       = azurerm_resource_group.key_vault.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.key_vault.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.key_vault.location
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
