#--------------------------------------------------------------
# Resource Group Outputs
#--------------------------------------------------------------

output "ampls_resource_group_name" {
  description = "Name of the Azure Monitor Private Link Scope resource group"
  value       = azurerm_resource_group.ampls_rg.name
}

output "ampls_resource_group_id" {
  description = "ID of the Azure Monitor Private Link Scope resource group"
  value       = azurerm_resource_group.ampls_rg.id
}

output "storage_resource_group_name" {
  description = "Name of the storage accounts resource group"
  value       = azurerm_resource_group.storage_rg.name
}

output "storage_resource_group_id" {
  description = "ID of the storage accounts resource group"
  value       = azurerm_resource_group.storage_rg.id
}

#--------------------------------------------------------------
# Azure Monitor Private Link Scope Outputs
#--------------------------------------------------------------

output "ampls_id" {
  description = "ID of the Azure Monitor Private Link Scope"
  value       = azurerm_monitor_private_link_scope.ampls.id
}

output "ampls_name" {
  description = "Name of the Azure Monitor Private Link Scope"
  value       = azurerm_monitor_private_link_scope.ampls.name
}

output "ampls_private_endpoint_id" {
  description = "ID of the Azure Monitor Private Link Scope private endpoint"
  value       = azurerm_private_endpoint.ampls_pe.id
}

output "ampls_private_endpoint_ip" {
  description = "Private IP addresses of the Azure Monitor Private Link Scope private endpoint"
  value       = azurerm_private_endpoint.ampls_pe.private_service_connection[0].private_ip_address
}

#--------------------------------------------------------------
# VM Storage Account Outputs
#--------------------------------------------------------------

output "vm_storage_account_id" {
  description = "ID of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm_storage.id
}

output "vm_storage_account_name" {
  description = "Name of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm_storage.name
}

output "vm_storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm_storage.primary_blob_endpoint
}

output "vm_storage_account_primary_access_key" {
  description = "Primary access key of the VM diagnostics storage account"
  value       = azurerm_storage_account.vm_storage.primary_access_key
  sensitive   = true
}

#--------------------------------------------------------------
# Network Storage Account Outputs
#--------------------------------------------------------------

output "ntwk_storage_account_id" {
  description = "ID of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk_storage.id
}

output "ntwk_storage_account_name" {
  description = "Name of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk_storage.name
}

output "ntwk_storage_account_primary_blob_endpoint" {
  description = "Primary blob endpoint of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk_storage.primary_blob_endpoint
}

output "ntwk_storage_account_primary_access_key" {
  description = "Primary access key of the network diagnostics storage account"
  value       = azurerm_storage_account.ntwk_storage.primary_access_key
  sensitive   = true
}

#--------------------------------------------------------------
# Private Endpoint Outputs
#--------------------------------------------------------------

output "vm_storage_private_endpoint_ids" {
  description = "IDs of the VM storage account private endpoints"
  value = {
    blob  = azurerm_private_endpoint.vm_storage_blob_pe.id
    file  = azurerm_private_endpoint.vm_storage_file_pe.id
    queue = azurerm_private_endpoint.vm_storage_queue_pe.id
    table = azurerm_private_endpoint.vm_storage_table_pe.id
  }
}

output "ntwk_storage_private_endpoint_ids" {
  description = "IDs of the network storage account private endpoints"
  value = {
    blob  = azurerm_private_endpoint.ntwk_storage_blob_pe.id
    file  = azurerm_private_endpoint.ntwk_storage_file_pe.id
    queue = azurerm_private_endpoint.ntwk_storage_queue_pe.id
    table = azurerm_private_endpoint.ntwk_storage_table_pe.id
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
  value       = azurerm_resource_group.ampls_rg.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.ampls_rg.id
}

output "location" {
  description = "The Azure region of the deployment"
  value       = azurerm_resource_group.ampls_rg.location
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
  value       = azurerm_resource_group.ampls_rg.name
}
