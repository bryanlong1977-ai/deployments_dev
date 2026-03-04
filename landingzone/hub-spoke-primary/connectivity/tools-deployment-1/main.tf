terraform {
  required_version = ">= 1.10.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.connectivity_subscription_id
}

# =============================================================================
# Resource Group for AMPLS
# =============================================================================
resource "azurerm_resource_group" "this" {
  name     = var.hub_azure_monitor_private_link_scope_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Azure Monitor Private Link Scope
# =============================================================================
resource "azurerm_monitor_private_link_scope" "this" {
  name                = var.hub_azure_monitor_private_link_scope_name
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

# =============================================================================
# Scoped Service - Link Log Analytics Workspace to AMPLS
# =============================================================================
resource "azurerm_monitor_private_link_scoped_service" "this" {
  name                = "scoped-service-law"
  resource_group_name = azurerm_resource_group.this.name
  scope_name          = azurerm_monitor_private_link_scope.this.name
  linked_resource_id  = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
}

# =============================================================================
# Private Endpoint for AMPLS
# =============================================================================
resource "azurerm_private_endpoint" "this" {
  name                = "pep-${var.hub_azure_monitor_private_link_scope_name}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_deployment_1.outputs.subnet_ids[var.snet_pe_hub_cus_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_azure_monitor_private_link_scope_name}"
    private_connection_resource_id = azurerm_monitor_private_link_scope.this.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "ampls-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.monitor.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.oms.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.ods.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.agentsvc.azure-automation.net"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"],
    ]
  }

  depends_on = [azurerm_monitor_private_link_scoped_service.this]
}
