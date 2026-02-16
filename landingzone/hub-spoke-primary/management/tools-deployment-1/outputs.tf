# Outputs for Tools Deployment 1 - Management Subscription
# These outputs are used by downstream deployments via terraform_remote_state

# ============================================================================
# RESOURCE GROUP OUTPUTS
# ============================================================================

output "kv_resource_group_name" {
  description = "Name of the Key Vault resource group"
  value       = azurerm_resource_group.kv.name
}

output "kv_resource_group_id" {
  description = "ID of the Key Vault resource group"
  value       = azurerm_resource_group.kv.id
}

output "log_resource_group_name" {
  description = "Name of the Log Analytics resource group"
  value       = azurerm_resource_group.log.name
}

output "log_resource_group_id" {
  description = "ID of the Log Analytics resource group"
  value       = azurerm_resource_group.log.id
}

output "mi_resource_group_name" {
  description = "Name of the Managed Identity resource group"
  value       = azurerm_resource_group.mi.name
}

output "mi_resource_group_id" {
  description = "ID of the Managed Identity resource group"
  value       = azurerm_resource_group.mi.id
}

# ============================================================================
# LOG ANALYTICS WORKSPACE OUTPUTS
# ============================================================================

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_workspace_id" {
  description = "Workspace ID (GUID) of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}

output "log_analytics_workspace_primary_shared_key" {
  description = "Primary shared key for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_secondary_shared_key" {
  description = "Secondary shared key for the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.secondary_shared_key
  sensitive   = true
}

# ============================================================================
# MANAGED IDENTITY OUTPUTS
# ============================================================================

output "managed_identity_id" {
  description = "ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.main.id
}

output "managed_identity_name" {
  description = "Name of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.main.name
}

output "managed_identity_principal_id" {
  description = "Principal ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.main.principal_id
}

output "managed_identity_client_id" {
  description = "Client ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.main.client_id
}

output "managed_identity_tenant_id" {
  description = "Tenant ID of the User Assigned Managed Identity"
  value       = azurerm_user_assigned_identity.main.tenant_id
}

# ============================================================================
# KEY VAULT OUTPUTS
# ============================================================================

output "key_vault_prd_id" {
  description = "ID of the Production Key Vault"
  value       = azurerm_key_vault.prd.id
}

output "key_vault_prd_name" {
  description = "Name of the Production Key Vault"
  value       = azurerm_key_vault.prd.name
}

output "key_vault_prd_uri" {
  description = "URI of the Production Key Vault"
  value       = azurerm_key_vault.prd.vault_uri
}

output "key_vault_nprd_id" {
  description = "ID of the Non-Production Key Vault"
  value       = azurerm_key_vault.nprd.id
}

output "key_vault_nprd_name" {
  description = "Name of the Non-Production Key Vault"
  value       = azurerm_key_vault.nprd.name
}

output "key_vault_nprd_uri" {
  description = "URI of the Non-Production Key Vault"
  value       = azurerm_key_vault.nprd.vault_uri
}

# ============================================================================
# PRIVATE ENDPOINT OUTPUTS
# ============================================================================

output "key_vault_prd_private_endpoint_id" {
  description = "ID of the Production Key Vault Private Endpoint"
  value       = azurerm_private_endpoint.kv_prd.id
}

output "key_vault_prd_private_ip" {
  description = "Private IP address of the Production Key Vault Private Endpoint"
  value       = azurerm_private_endpoint.kv_prd.private_service_connection[0].private_ip_address
}

output "key_vault_nprd_private_endpoint_id" {
  description = "ID of the Non-Production Key Vault Private Endpoint"
  value       = azurerm_private_endpoint.kv_nprd.id
}

output "key_vault_nprd_private_ip" {
  description = "Private IP address of the Non-Production Key Vault Private Endpoint"
  value       = azurerm_private_endpoint.kv_nprd.private_service_connection[0].private_ip_address
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
  value       = azurerm_resource_group.kv.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.kv.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.kv.location
}
