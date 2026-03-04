output "ampls_id" {
  description = "The ID of the Azure Monitor Private Link Scope."
  value       = azurerm_monitor_private_link_scope.this.id
}

output "ampls_name" {
  description = "The name of the Azure Monitor Private Link Scope."
  value       = azurerm_monitor_private_link_scope.this.name
}

output "ampls_resource_group_name" {
  description = "The resource group name containing the AMPLS resources."
  value       = azurerm_resource_group.this.name
}

output "ampls_resource_group_id" {
  description = "The ID of the resource group containing the AMPLS resources."
  value       = azurerm_resource_group.this.id
}

output "ampls_private_endpoint_id" {
  description = "The ID of the AMPLS private endpoint."
  value       = azurerm_private_endpoint.this.id
}

output "ampls_private_endpoint_ip" {
  description = "The private IP address of the AMPLS private endpoint."
  value       = azurerm_private_endpoint.this.private_service_connection[0].private_ip_address
}

output "ampls_scoped_service_law_id" {
  description = "The ID of the scoped service linking Log Analytics Workspace to AMPLS."
  value       = azurerm_monitor_private_link_scoped_service.this.id
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
  value       = azurerm_resource_group.this.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.this.location
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
  value       = azurerm_resource_group.this.name
}
