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
  subscription_id = var.identity_subscription_id
}

# =============================================================================
# Resource Groups
# =============================================================================

resource "azurerm_resource_group" "rsv" {
  name     = var.idm_recovery_services_vault_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "storage" {
  name     = var.idm_storage_account_vm_resource_group
  location = var.region
  tags     = var.tags
}

# =============================================================================
# Recovery Services Vault
# =============================================================================

resource "azurerm_recovery_services_vault" "this" {
  name                = var.idm_recovery_services_vault_name
  location            = azurerm_resource_group.rsv.location
  resource_group_name = azurerm_resource_group.rsv.name
  sku                 = "Standard"
  soft_delete_enabled = true

  tags = var.tags
}

# Diagnostic Settings for Recovery Services Vault
resource "azurerm_monitor_diagnostic_setting" "rsv" {
  name                       = "diag-${var.idm_recovery_services_vault_name}"
  target_resource_id         = azurerm_recovery_services_vault.this.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "CoreAzureBackup"
  }

  enabled_log {
    category = "AddonAzureBackupJobs"
  }

  enabled_log {
    category = "AddonAzureBackupAlerts"
  }

  enabled_log {
    category = "AddonAzureBackupPolicy"
  }

  enabled_log {
    category = "AddonAzureBackupStorage"
  }

  enabled_log {
    category = "AddonAzureBackupProtectedInstance"
  }

  enabled_log {
    category = "AzureSiteRecoveryJobs"
  }

  enabled_log {
    category = "AzureSiteRecoveryEvents"
  }

  enabled_log {
    category = "AzureSiteRecoveryReplicatedItems"
  }

  enabled_log {
    category = "AzureSiteRecoveryReplicationStats"
  }

  enabled_log {
    category = "AzureSiteRecoveryRecoveryPoints"
  }

  enabled_log {
    category = "AzureSiteRecoveryReplicationDataUploadRate"
  }

  enabled_log {
    category = "AzureSiteRecoveryProtectedDiskDataChurn"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Private Endpoint for Recovery Services Vault
resource "azurerm_private_endpoint" "rsv" {
  name                = "pep-${var.idm_recovery_services_vault_name}"
  location            = azurerm_resource_group.rsv.location
  resource_group_name = azurerm_resource_group.rsv.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_recovery_services_vault_name}"
    private_connection_resource_id = azurerm_recovery_services_vault.this.id
    subresource_names              = ["AzureBackup"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.eus2.backup.windowsazure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"],
    ]
  }

  tags = var.tags
}

# =============================================================================
# Storage Account - VM Diagnostics
# =============================================================================

resource "azurerm_storage_account" "vm" {
  name                     = var.idm_storage_account_vm_name
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Diagnostic Settings for VM Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.idm_storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for VM Storage Account - Blob Service
resource "azurerm_monitor_diagnostic_setting" "storage_vm_blob" {
  name                       = "diag-${var.idm_storage_account_vm_name}-blob"
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

# Private Endpoints for VM Storage Account
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = "pep-${var.idm_storage_account_vm_name}-blob"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"],
    ]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_file" {
  name                = "pep-${var.idm_storage_account_vm_name}-file"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"],
    ]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_queue" {
  name                = "pep-${var.idm_storage_account_vm_name}-queue"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"],
    ]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_table" {
  name                = "pep-${var.idm_storage_account_vm_name}-table"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"],
    ]
  }

  tags = var.tags
}

# =============================================================================
# Storage Account - Network Diagnostics
# =============================================================================

resource "azurerm_storage_account" "ntwk" {
  name                     = var.idm_storage_account_ntwk_name
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# Diagnostic Settings for Network Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk" {
  name                       = "diag-${var.idm_storage_account_ntwk_name}"
  target_resource_id         = azurerm_storage_account.ntwk.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for Network Storage Account - Blob Service
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_blob" {
  name                       = "diag-${var.idm_storage_account_ntwk_name}-blob"
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

# Private Endpoints for Network Storage Account
resource "azurerm_private_endpoint" "storage_ntwk_blob" {
  name                = "pep-${var.idm_storage_account_ntwk_name}-blob"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"],
    ]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_file" {
  name                = "pep-${var.idm_storage_account_ntwk_name}-file"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_storage_account_ntwk_name}-file"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"],
    ]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_queue" {
  name                = "pep-${var.idm_storage_account_ntwk_name}-queue"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_storage_account_ntwk_name}-queue"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"],
    ]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_table" {
  name                = "pep-${var.idm_storage_account_ntwk_name}-table"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids[var.snet_pe_idm_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.idm_storage_account_ntwk_name}-table"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"],
    ]
  }

  tags = var.tags
}