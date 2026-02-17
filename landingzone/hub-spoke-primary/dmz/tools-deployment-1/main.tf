terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    recovery_services_vaults {
      recover_soft_deleted_backup_protected_vm = true
    }
  }
  subscription_id = var.subscription_id
}

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Resource Group for Storage Accounts
resource "azurerm_resource_group" "storage" {
  name     = var.storage_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Recovery Services Vault
resource "azurerm_resource_group" "rsv" {
  name     = var.rsv_resource_group_name
  location = var.region
  tags     = var.tags
}

# Storage Account for VM diagnostics
resource "azurerm_storage_account" "vm" {
  name                            = var.storage_account_vm_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = azurerm_resource_group.storage.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_min_tls_version
  public_network_access_enabled   = var.storage_public_network_access_enabled
  allow_nested_items_to_be_public = var.storage_allow_nested_items_public
  shared_access_key_enabled       = var.storage_shared_access_key_enabled
  https_traffic_only_enabled      = var.storage_https_traffic_only_enabled

  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_delete_retention_days
    }
  }

  tags = var.tags
}

# Storage Account for Network diagnostics
resource "azurerm_storage_account" "net" {
  name                            = var.storage_account_net_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = azurerm_resource_group.storage.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_min_tls_version
  public_network_access_enabled   = var.storage_public_network_access_enabled
  allow_nested_items_to_be_public = var.storage_allow_nested_items_public
  shared_access_key_enabled       = var.storage_shared_access_key_enabled
  https_traffic_only_enabled      = var.storage_https_traffic_only_enabled

  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_delete_retention_days
    }
  }

  tags = var.tags
}

# Private Endpoint for VM Storage Account - Blob
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = var.pe_storage_vm_blob_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

# Private Endpoint for VM Storage Account - File
resource "azurerm_private_endpoint" "storage_vm_file" {
  name                = var.pe_storage_vm_file_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

# Private Endpoint for VM Storage Account - Queue
resource "azurerm_private_endpoint" "storage_vm_queue" {
  name                = var.pe_storage_vm_queue_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

# Private Endpoint for VM Storage Account - Table
resource "azurerm_private_endpoint" "storage_vm_table" {
  name                = var.pe_storage_vm_table_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}

# Private Endpoint for Net Storage Account - Blob
resource "azurerm_private_endpoint" "storage_net_blob" {
  name                = var.pe_storage_net_blob_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_net_name}-blob"
    private_connection_resource_id = azurerm_storage_account.net.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

# Private Endpoint for Net Storage Account - File
resource "azurerm_private_endpoint" "storage_net_file" {
  name                = var.pe_storage_net_file_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_net_name}-file"
    private_connection_resource_id = azurerm_storage_account.net.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

# Private Endpoint for Net Storage Account - Queue
resource "azurerm_private_endpoint" "storage_net_queue" {
  name                = var.pe_storage_net_queue_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_net_name}-queue"
    private_connection_resource_id = azurerm_storage_account.net.id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

# Private Endpoint for Net Storage Account - Table
resource "azurerm_private_endpoint" "storage_net_table" {
  name                = var.pe_storage_net_table_name
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.dmz_network_deployment_1.outputs.subnet_ids["snet-pe-dmz-wus3-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_net_name}-table"
    private_connection_resource_id = azurerm_storage_account.net.id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name                 = "pdnszg-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}

# Diagnostic Settings for VM Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Diagnostic Settings for VM Storage Account - Blob Service
resource "azurerm_monitor_diagnostic_setting" "storage_vm_blob" {
  name                       = "diag-${var.storage_account_vm_name}-blob"
  target_resource_id         = "${azurerm_storage_account.vm.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Diagnostic Settings for Net Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_net" {
  name                       = "diag-${var.storage_account_net_name}"
  target_resource_id         = azurerm_storage_account.net.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

# Diagnostic Settings for Net Storage Account - Blob Service
resource "azurerm_monitor_diagnostic_setting" "storage_net_blob" {
  name                       = "diag-${var.storage_account_net_name}-blob"
  target_resource_id         = "${azurerm_storage_account.net.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "Transaction"
    enabled  = true
  }
}