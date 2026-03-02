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
# Resource Groups
# =============================================================================

# Resource Group for AMPLS
resource "azurerm_resource_group" "ampls" {
  name     = var.hub_azure_monitor_private_link_scope_resource_group
  location = var.region
  tags     = var.tags
}

# Resource Group for Storage Accounts
resource "azurerm_resource_group" "storage" {
  name     = var.hub_storage_account_vm_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Azure Monitor Private Link Scope (AMPLS)
# =============================================================================

resource "azurerm_monitor_private_link_scope" "this" {
  name                = var.hub_azure_monitor_private_link_scope_name
  resource_group_name = azurerm_resource_group.ampls.name
  tags                = var.tags
}

# Link AMPLS to Log Analytics Workspace in Management Subscription
resource "azurerm_monitor_private_link_scoped_service" "this" {
  name                = "scoped-service-law"
  resource_group_name = azurerm_resource_group.ampls.name
  scope_name          = azurerm_monitor_private_link_scope.this.name
  linked_resource_id  = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
}

# Private Endpoint for AMPLS
resource "azurerm_private_endpoint" "ampls" {
  name                = "pe-${var.hub_azure_monitor_private_link_scope_name}"
  resource_group_name = azurerm_resource_group.ampls.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-ampls"
    private_connection_resource_id = azurerm_monitor_private_link_scope.this.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "ampls-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.monitor.azure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.oms.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.ods.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.agentsvc.azure-automation.net"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"],
    ]
  }

  depends_on = [azurerm_monitor_private_link_scoped_service.this]
}

# =============================================================================
# Storage Account - VM Diagnostics
# =============================================================================

resource "azurerm_storage_account" "vm" {
  name                     = var.hub_storage_account_vm_name
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  public_network_access_enabled = false

  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Private Endpoint for VM Storage Account - Blob
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = "pe-${var.hub_storage_account_vm_name}-blob"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "blob-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"],
    ]
  }
}

# Diagnostic Settings for VM Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.hub_storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for VM Storage Account - Blob Service
resource "azurerm_monitor_diagnostic_setting" "storage_vm_blob" {
  name                       = "diag-${var.hub_storage_account_vm_name}-blob"
  target_resource_id         = "${azurerm_storage_account.vm.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for VM Storage Account - File Service
resource "azurerm_monitor_diagnostic_setting" "storage_vm_file" {
  name                       = "diag-${var.hub_storage_account_vm_name}-file"
  target_resource_id         = "${azurerm_storage_account.vm.id}/fileServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for VM Storage Account - Queue Service
resource "azurerm_monitor_diagnostic_setting" "storage_vm_queue" {
  name                       = "diag-${var.hub_storage_account_vm_name}-queue"
  target_resource_id         = "${azurerm_storage_account.vm.id}/queueServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for VM Storage Account - Table Service
resource "azurerm_monitor_diagnostic_setting" "storage_vm_table" {
  name                       = "diag-${var.hub_storage_account_vm_name}-table"
  target_resource_id         = "${azurerm_storage_account.vm.id}/tableServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# =============================================================================
# Storage Account - Network Diagnostics
# =============================================================================

resource "azurerm_storage_account" "ntwk" {
  name                     = var.hub_storage_account_ntwk_name
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  public_network_access_enabled = false

  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Private Endpoint for Network Storage Account - Blob
resource "azurerm_private_endpoint" "storage_ntwk_blob" {
  name                = "pe-${var.hub_storage_account_ntwk_name}-blob"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "blob-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"],
    ]
  }
}

# Diagnostic Settings for Network Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk" {
  name                       = "diag-${var.hub_storage_account_ntwk_name}"
  target_resource_id         = azurerm_storage_account.ntwk.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for Network Storage Account - Blob Service
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_blob" {
  name                       = "diag-${var.hub_storage_account_ntwk_name}-blob"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for Network Storage Account - File Service
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_file" {
  name                       = "diag-${var.hub_storage_account_ntwk_name}-file"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/fileServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for Network Storage Account - Queue Service
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_queue" {
  name                       = "diag-${var.hub_storage_account_ntwk_name}-queue"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/queueServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for Network Storage Account - Table Service
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_table" {
  name                       = "diag-${var.hub_storage_account_ntwk_name}-table"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/tableServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}