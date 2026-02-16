# Management Network Deployment 2 - Configuration Only
# This deployment configures diagnostic settings, VNet flow logs, and DNS zone links
# for existing resources created in Network Deployment 1

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Primary provider for Management subscription
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Provider for Identity subscription (for DNS zone links)
provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# Provider for Connectivity subscription (for storage account reference)
provider "azurerm" {
  alias           = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

#--------------------------------------------------------------
# Local Values
#--------------------------------------------------------------
locals {
  tags = {
    customer      = var.customer_name
    project       = var.project_name
    environment   = var.environment
    deployment_id = var.deployment_id
    deployed_by   = "terraform"
    deployment    = "network-deployment-2"
  }

  # Private DNS zones to link to the Management VNet
  private_dns_zones = var.private_dns_zones
}

#--------------------------------------------------------------
# Data Sources for Existing Resources
#--------------------------------------------------------------

# Reference the VNet from Network Deployment 1 via remote state
# VNet ID and name come from: data.terraform_remote_state.management_network_deployment_1.outputs

# Reference the Log Analytics Workspace from Management Tools Deployment 1
# LAW ID comes from: data.terraform_remote_state.management_tools_deployment_1.outputs

# Reference the Network Storage Account from Management Tools Deployment 2
# Storage Account ID comes from: data.terraform_remote_state.management_tools_deployment_2.outputs

# Reference Network Watcher from Network Deployment 1
# Network Watcher comes from: data.terraform_remote_state.management_network_deployment_1.outputs

#--------------------------------------------------------------
# Diagnostic Settings for Virtual Network
#--------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "vnet_diagnostics" {
  name                       = var.vnet_diagnostic_setting_name
  target_resource_id         = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  metric {
    category = "AllMetrics"
    enabled  = var.enable_metrics
  }
}

#--------------------------------------------------------------
# Virtual Network Flow Logs
#--------------------------------------------------------------
resource "azurerm_network_watcher_flow_log" "vnet_flow_log" {
  name                 = var.vnet_flow_log_name
  network_watcher_name = data.terraform_remote_state.management_network_deployment_1.outputs.network_watcher_name
  resource_group_name  = data.terraform_remote_state.management_network_deployment_1.outputs.network_watcher_resource_group_name
  target_resource_id   = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_id
  storage_account_id   = data.terraform_remote_state.management_tools_deployment_2.outputs.network_storage_account_id
  enabled              = var.enable_flow_logs
  version              = var.flow_log_version

  retention_policy {
    enabled = var.flow_log_retention_enabled
    days    = var.flow_log_retention_days
  }

  traffic_analytics {
    enabled               = var.enable_traffic_analytics
    workspace_id          = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_workspace_id
    workspace_region      = var.region
    workspace_resource_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id
    interval_in_minutes   = var.traffic_analytics_interval
  }

  tags = local.tags
}

#--------------------------------------------------------------
# Private DNS Zone Virtual Network Links
# Link the Management VNet to Private DNS Zones in Identity subscription
#--------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_links" {
  provider = azurerm.identity
  for_each = toset(local.private_dns_zones)

  name                  = "link-${var.vnet_name}-${replace(each.value, ".", "-")}"
  resource_group_name   = var.dns_resource_group_name
  private_dns_zone_name = each.value
  virtual_network_id    = data.terraform_remote_state.management_network_deployment_1.outputs.vnet_id
  registration_enabled  = var.dns_auto_registration_enabled

  tags = local.tags
}