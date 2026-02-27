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

# ============================================
# Resource Groups
# ============================================

resource "azurerm_resource_group" "mpls" {
  name     = var.hub_azure_monitor_private_link_scope_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "storage" {
  name     = var.hub_storage_account_vm_resource_group
  location = var.region
  tags     = var.tags
}

# ============================================
# Azure Monitor Private Link Scope
# ============================================

resource "azurerm_monitor_private_link_scope" "this" {
  name                = var.hub_azure_monitor_private_link_scope_name
  resource_group_name = azurerm_resource_group.mpls.name
  tags                = var.tags
}

# Link AMPLS to the Log Analytics Workspace in Management Subscription
resource "azurerm_monitor_private_link_scoped_service" "this" {
  name                = "scoped-service-law"
  resource_group_name = azurerm_resource_group.mpls.name
  scope_name          = azurerm_monitor_private_link_scope.this.name
  linked_resource_id  = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
}

# Private Endpoint for AMPLS
resource "azurerm_private_endpoint" "mpls" {
  name                = "pep-${var.hub_azure_monitor_private_link_scope_name}"
  resource_group_name = azurerm_resource_group.mpls.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
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
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.monitor.azure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.oms.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.ods.opinsights.azure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.agentsvc.azure-automation.net"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"],
    ]
  }
}

# ============================================
# Storage Accounts
# ============================================

# VM Storage Account
resource "azurerm_storage_account" "vm" {
  name                            = var.hub_storage_account_vm_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = var.region
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

# Network Storage Account
resource "azurerm_storage_account" "ntwk" {
  name                            = var.hub_storage_account_ntwk_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = var.region
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

# ============================================
# Private Endpoints for VM Storage Account
# ============================================

resource "azurerm_private_endpoint" "vm_blob" {
  name                = "pep-${var.hub_storage_account_vm_name}-blob"
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

resource "azurerm_private_endpoint" "vm_file" {
  name                = "pep-${var.hub_storage_account_vm_name}-file"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "file-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"],
    ]
  }
}

resource "azurerm_private_endpoint" "vm_queue" {
  name                = "pep-${var.hub_storage_account_vm_name}-queue"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "queue-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"],
    ]
  }
}

resource "azurerm_private_endpoint" "vm_table" {
  name                = "pep-${var.hub_storage_account_vm_name}-table"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "table-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"],
    ]
  }
}

# ============================================
# Private Endpoints for Network Storage Account
# ============================================

resource "azurerm_private_endpoint" "ntwk_blob" {
  name                = "pep-${var.hub_storage_account_ntwk_name}-blob"
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

resource "azurerm_private_endpoint" "ntwk_file" {
  name                = "pep-${var.hub_storage_account_ntwk_name}-file"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_storage_account_ntwk_name}-file"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "file-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"],
    ]
  }
}

resource "azurerm_private_endpoint" "ntwk_queue" {
  name                = "pep-${var.hub_storage_account_ntwk_name}-queue"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_storage_account_ntwk_name}-queue"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "queue-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"],
    ]
  }
}

resource "azurerm_private_endpoint" "ntwk_table" {
  name                = "pep-${var.hub_storage_account_ntwk_name}-table"
  resource_group_name = azurerm_resource_group.storage.name
  location            = var.region
  subnet_id           = data.terraform_remote_state.connectivity_network_1.outputs.subnet_ids[var.snet_pe_hub_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.hub_storage_account_ntwk_name}-table"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "table-dns-group"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"],
    ]
  }
}

# ============================================
# Diagnostic Settings - Storage Accounts
# ============================================

# VM Storage Account - Account level diagnostics
resource "azurerm_monitor_diagnostic_setting" "vm_storage" {
  name                       = "diag-${var.hub_storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# VM Storage Account - Blob service diagnostics
resource "azurerm_monitor_diagnostic_setting" "vm_storage_blob" {
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

# VM Storage Account - File service diagnostics
resource "azurerm_monitor_diagnostic_setting" "vm_storage_file" {
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

# VM Storage Account - Queue service diagnostics
resource "azurerm_monitor_diagnostic_setting" "vm_storage_queue" {
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

# VM Storage Account - Table service diagnostics
resource "azurerm_monitor_diagnostic_setting" "vm_storage_table" {
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

# Network Storage Account - Account level diagnostics
resource "azurerm_monitor_diagnostic_setting" "ntwk_storage" {
  name                       = "diag-${var.hub_storage_account_ntwk_name}"
  target_resource_id         = azurerm_storage_account.ntwk.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Network Storage Account - Blob service diagnostics
resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_blob" {
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

# Network Storage Account - File service diagnostics
resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_file" {
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

# Network Storage Account - Queue service diagnostics
resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_queue" {
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

# Network Storage Account - Table service diagnostics
resource "azurerm_monitor_diagnostic_setting" "ntwk_storage_table" {
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