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

# Resource Groups
resource "azurerm_resource_group" "automation_account" {
  name     = var.automation_account_resource_group_name
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "recovery_services_vault" {
  name     = var.recovery_services_vault_resource_group_name
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "storage_account" {
  name     = var.storage_account_resource_group_name
  location = var.region
  tags     = var.tags
}

# Automation Account
resource "azurerm_automation_account" "main" {
  name                = var.automation_account_name
  location            = var.region
  resource_group_name = azurerm_resource_group.automation_account.name
  sku_name            = var.automation_account_sku

  public_network_access_enabled = var.automation_account_public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Link Automation Account to Log Analytics Workspace
resource "azurerm_log_analytics_linked_service" "automation" {
  resource_group_name = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_resource_group_name
  workspace_id        = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id
  read_access_id      = azurerm_automation_account.main.id
}

# Automation Account Private Endpoint
resource "azurerm_private_endpoint" "automation_account" {
  name                = var.automation_account_private_endpoint_name
  location            = var.region
  resource_group_name = azurerm_resource_group.automation_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.automation_account_name}"
    private_connection_resource_id = azurerm_automation_account.main.id
    subresource_names              = ["Webhook"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-automation"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.azure-automation.net"]]
  }

  tags = var.tags
}

# Automation Account Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "automation_account" {
  name                       = "diag-${var.automation_account_name}"
  target_resource_id         = azurerm_automation_account.main.id
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "JobLogs"
  }

  enabled_log {
    category = "JobStreams"
  }

  enabled_log {
    category = "DscNodeStatus"
  }

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Recovery Services Vault
resource "azurerm_recovery_services_vault" "main" {
  name                = var.recovery_services_vault_name
  location            = var.region
  resource_group_name = azurerm_resource_group.recovery_services_vault.name
  sku                 = var.recovery_services_vault_sku

  soft_delete_enabled             = var.recovery_services_vault_soft_delete_enabled
  storage_mode_type               = var.recovery_services_vault_storage_mode_type
  cross_region_restore_enabled    = var.recovery_services_vault_cross_region_restore_enabled
  public_network_access_enabled   = var.recovery_services_vault_public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Recovery Services Vault Private Endpoint
resource "azurerm_private_endpoint" "recovery_services_vault" {
  name                = var.recovery_services_vault_private_endpoint_name
  location            = var.region
  resource_group_name = azurerm_resource_group.recovery_services_vault.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.recovery_services_vault_name}"
    private_connection_resource_id = azurerm_recovery_services_vault.main.id
    subresource_names              = ["AzureBackup"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "pdnszg-rsv"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.eus2.backup.windowsazure.com"],
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]
    ]
  }

  tags = var.tags
}

# Recovery Services Vault Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "recovery_services_vault" {
  name                       = "diag-${var.recovery_services_vault_name}"
  target_resource_id         = azurerm_recovery_services_vault.main.id
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

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
}

# Storage Account - VM Diagnostics
resource "azurerm_storage_account" "vm" {
  name                     = var.storage_account_vm_name
  resource_group_name      = azurerm_resource_group.storage_account.name
  location                 = var.region
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
  min_tls_version          = var.storage_account_min_tls_version

  public_network_access_enabled   = var.storage_account_public_network_access_enabled
  allow_nested_items_to_be_public = var.storage_account_allow_nested_items_to_be_public

  blob_properties {
    delete_retention_policy {
      days = var.storage_account_blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_account_container_delete_retention_days
    }
  }

  tags = var.tags
}

# Storage Account - Network Diagnostics
resource "azurerm_storage_account" "ntwk" {
  name                     = var.storage_account_ntwk_name
  resource_group_name      = azurerm_resource_group.storage_account.name
  location                 = var.region
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind             = var.storage_account_kind
  min_tls_version          = var.storage_account_min_tls_version

  public_network_access_enabled   = var.storage_account_public_network_access_enabled
  allow_nested_items_to_be_public = var.storage_account_allow_nested_items_to_be_public

  blob_properties {
    delete_retention_policy {
      days = var.storage_account_blob_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.storage_account_container_delete_retention_days
    }
  }

  tags = var.tags
}

# Private Endpoints for VM Storage Account
resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = "pep-${var.storage_account_vm_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_file" {
  name                = "pep-${var.storage_account_vm_name}-file"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-file"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_queue" {
  name                = "pep-${var.storage_account_vm_name}-queue"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-queue"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_vm_table" {
  name                = "pep-${var.storage_account_vm_name}-table"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_vm_name}-table"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}

# Private Endpoints for Network Storage Account
resource "azurerm_private_endpoint" "storage_ntwk_blob" {
  name                = "pep-${var.storage_account_ntwk_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-blob"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_file" {
  name                = "pep-${var.storage_account_ntwk_name}-file"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-file"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-file"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.file.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_queue" {
  name                = "pep-${var.storage_account_ntwk_name}-queue"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-queue"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-queue"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.queue.core.windows.net"]]
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "storage_ntwk_table" {
  name                = "pep-${var.storage_account_ntwk_name}-table"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.network_deployment_1.outputs.subnet_ids["snet-pe-mgmt-eus2-01"]

  private_service_connection {
    name                           = "psc-${var.storage_account_ntwk_name}-table"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["table"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdnszg-table"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.table.core.windows.net"]]
  }

  tags = var.tags
}

# Storage Account Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage_vm_blob" {
  name                       = "diag-${var.storage_account_vm_name}-blob"
  target_resource_id         = "${azurerm_storage_account.vm.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

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

resource "azurerm_monitor_diagnostic_setting" "storage_ntwk" {
  name                       = "diag-${var.storage_account_ntwk_name}"
  target_resource_id         = azurerm_storage_account.ntwk.id
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

  metric {
    category = "Transaction"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_blob" {
  name                       = "diag-${var.storage_account_ntwk_name}-blob"
  target_resource_id         = "${azurerm_storage_account.ntwk.id}/blobServices/default"
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

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

# Diagnostic Settings for Tools Deployment 1 Resources (Key Vaults)
resource "azurerm_monitor_diagnostic_setting" "key_vault_prd" {
  name                       = "diag-${data.terraform_remote_state.tools_deployment_1.outputs.key_vault_prd_name}"
  target_resource_id         = data.terraform_remote_state.tools_deployment_1.outputs.key_vault_prd_id
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "key_vault_nprd" {
  name                       = "diag-${data.terraform_remote_state.tools_deployment_1.outputs.key_vault_nprd_name}"
  target_resource_id         = data.terraform_remote_state.tools_deployment_1.outputs.key_vault_nprd_id
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic Settings for Log Analytics Workspace
resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  name                       = "diag-${data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_name}"
  target_resource_id         = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id
  log_analytics_workspace_id = data.terraform_remote_state.tools_deployment_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "Audit"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}