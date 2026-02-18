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

# Provider for Identity subscription (for private DNS zone links)
provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# Provider for Management subscription (for Log Analytics)
provider "azurerm" {
  alias           = "management"
  features {}
  subscription_id = var.management_subscription_id
}

#--------------------------------------------------------------
# Resource Groups
#--------------------------------------------------------------

# Resource Group for Recovery Services Vault
resource "azurerm_resource_group" "rsv" {
  name     = var.rsv_resource_group_name
  location = var.region
  tags     = var.tags
}

# Resource Group for Storage Accounts
resource "azurerm_resource_group" "storage" {
  name     = var.storage_resource_group_name
  location = var.region
  tags     = var.tags
}

#--------------------------------------------------------------
# Recovery Services Vault
#--------------------------------------------------------------

resource "azurerm_recovery_services_vault" "rsv" {
  name                          = var.rsv_name
  location                      = azurerm_resource_group.rsv.location
  resource_group_name           = azurerm_resource_group.rsv.name
  sku                           = var.rsv_sku
  soft_delete_enabled           = var.rsv_soft_delete_enabled
  storage_mode_type             = var.rsv_storage_mode_type
  cross_region_restore_enabled  = var.rsv_cross_region_restore_enabled
  public_network_access_enabled = var.rsv_public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Diagnostic Settings for Recovery Services Vault
resource "azurerm_monitor_diagnostic_setting" "rsv" {
  name                       = "diag-${var.rsv_name}"
  target_resource_id         = azurerm_recovery_services_vault.rsv.id
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
    category = "AzureBackupReport"
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

  metric {
    category = "Health"
    enabled  = true
  }
}

# Private Endpoint for Recovery Services Vault - Backup
resource "azurerm_private_endpoint" "rsv_backup" {
  name                = "pep-${var.rsv_name}-backup"
  location            = azurerm_resource_group.rsv.location
  resource_group_name = azurerm_resource_group.rsv.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.rsv_name}-backup"
    private_connection_resource_id = azurerm_recovery_services_vault.rsv.id
    subresource_names              = ["AzureBackup"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.rsv_name}-backup"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.eus2.backup.windowsazure.com"]]
  }

  tags = var.tags
}

# Private Endpoint for Recovery Services Vault - Site Recovery
resource "azurerm_private_endpoint" "rsv_siterecovery" {
  name                = "pep-${var.rsv_name}-siterecovery"
  location            = azurerm_resource_group.rsv.location
  resource_group_name = azurerm_resource_group.rsv.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.rsv_name}-siterecovery"
    private_connection_resource_id = azurerm_recovery_services_vault.rsv.id
    subresource_names              = ["AzureSiteRecovery"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.rsv_name}-siterecovery"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.siterecovery.windowsazure.com"]]
  }

  tags = var.tags
}

#--------------------------------------------------------------
# Storage Account - VM Diagnostics
#--------------------------------------------------------------

resource "azurerm_storage_account" "vm" {
  name                            = var.storage_account_vm_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = azurerm_resource_group.storage.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_min_tls_version
  https_traffic_only_enabled      = var.storage_https_only
  public_network_access_enabled   = var.storage_public_network_access_enabled
  allow_nested_items_to_be_public = var.storage_allow_nested_items_public

  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_retention_days
    }
  }

  tags = var.tags
}

# Diagnostic Settings for VM Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Diagnostic Settings for VM Storage Account - Blob
resource "azurerm_monitor_diagnostic_setting" "storage_vm_blob" {
  name                       = "diag-${var.storage_account_vm_name}-blob"
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

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Private Endpoints for VM Storage Account
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = "pep-${var.storage_account_vm_name}-blob"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.storage_account_vm_name}-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_file" {
  name                = "pep-${var.storage_account_vm_name}-file"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.storage_account_vm_name}-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_queue" {
  name                = "pep-${var.storage_account_vm_name}-queue"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.storage_account_vm_name}-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_table" {
  name                = "pep-${var.storage_account_vm_name}-table"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.storage_account_vm_name}-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}

#--------------------------------------------------------------
# Storage Account - Network Diagnostics
#--------------------------------------------------------------

resource "azurerm_storage_account" "ntwk" {
  name                            = var.storage_account_ntwk_name
  resource_group_name             = azurerm_resource_group.storage.name
  location                        = azurerm_resource_group.storage.location
  account_tier                    = var.storage_account_tier
  account_replication_type        = var.storage_account_replication_type
  account_kind                    = var.storage_account_kind
  min_tls_version                 = var.storage_min_tls_version
  https_traffic_only_enabled      = var.storage_https_only
  public_network_access_enabled   = var.storage_public_network_access_enabled
  allow_nested_items_to_be_public = var.storage_allow_nested_items_public

  blob_properties {
    delete_retention_policy {
      days = var.storage_blob_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_container_retention_days
    }
  }

  tags = var.tags
}

# Diagnostic Settings for Network Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk" {
  name                       = "diag-${var.storage_account_ntwk_name}"
  target_resource_id         = azurerm_storage_account.ntwk.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Diagnostic Settings for Network Storage Account - Blob
resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_blob" {
  name                       = "diag-${var.storage_account_ntwk_name}-blob"
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

  metric {
    category = "Transaction"
    enabled  = true
  }

  metric {
    category = "Capacity"
    enabled  = true
  }
}

# Private Endpoints for Network Storage Account
resource "azurerm_private_endpoint" "storage_ntwk_blob" {
  name                = "pep-${var.storage_account_ntwk_name}-blob"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.storage_account_ntwk_name}-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_file" {
  name                = "pep-${var.storage_account_ntwk_name}-file"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-file"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.storage_account_ntwk_name}-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_queue" {
  name                = "pep-${var.storage_account_ntwk_name}-queue"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-queue"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.storage_account_ntwk_name}-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_table" {
  name                = "pep-${var.storage_account_ntwk_name}-table"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  subnet_id           = data.terraform_remote_state.identity_network_1.outputs.subnet_ids["snet-pe-idm-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-table"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-${var.storage_account_ntwk_name}-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}