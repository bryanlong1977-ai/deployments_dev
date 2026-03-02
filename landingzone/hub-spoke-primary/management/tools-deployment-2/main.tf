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
  subscription_id = var.management_subscription_id
}

provider "azurerm" {
  alias           = "identity"
  features {}
  subscription_id = var.identity_subscription_id
}

# ============================================
# Resource Groups
# ============================================

resource "azurerm_resource_group" "automation_account" {
  name     = var.mgmt_automation_account_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "recovery_services_vault" {
  name     = var.mgmt_recovery_services_vault_resource_group
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "storage_account" {
  name     = var.mgmt_storage_account_vm_resource_group
  location = var.region
  tags     = var.tags
}

# ============================================
# Automation Account
# ============================================

resource "azurerm_automation_account" "this" {
  name                = var.mgmt_automation_account_name
  location            = var.region
  resource_group_name = azurerm_resource_group.automation_account.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_log_analytics_linked_service" "this" {
  resource_group_name = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_resource_group_name
  workspace_id        = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
  read_access_id      = azurerm_automation_account.this.id
}

# ============================================
# Recovery Services Vault
# ============================================

resource "azurerm_recovery_services_vault" "this" {
  name                = var.mgmt_recovery_services_vault_name
  location            = var.region
  resource_group_name = azurerm_resource_group.recovery_services_vault.name
  sku                 = "Standard"
  soft_delete_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# ============================================
# Storage Accounts
# ============================================

resource "azurerm_storage_account" "vm" {
  name                            = var.mgmt_storage_account_vm_name
  resource_group_name             = azurerm_resource_group.storage_account.name
  location                        = var.region
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = var.tags
}

resource "azurerm_storage_account" "ntwk" {
  name                            = var.mgmt_storage_account_ntwk_name
  resource_group_name             = azurerm_resource_group.storage_account.name
  location                        = var.region
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  tags = var.tags
}

# ============================================
# Private Endpoints - Storage Account VM (blob)
# ============================================

resource "azurerm_private_endpoint" "storage_vm_blob" {
  name                = "pe-${var.mgmt_storage_account_vm_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_vm_name}-blob"
    private_connection_resource_id = azurerm_storage_account.vm.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

# ============================================
# Private Endpoints - Storage Account NTWK (blob)
# ============================================

resource "azurerm_private_endpoint" "storage_ntwk_blob" {
  name                = "pe-${var.mgmt_storage_account_ntwk_name}-blob"
  location            = var.region
  resource_group_name = azurerm_resource_group.storage_account.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_storage_account_ntwk_name}-blob"
    private_connection_resource_id = azurerm_storage_account.ntwk.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]]
  }

  tags = var.tags
}

# ============================================
# Private Endpoint - Automation Account
# ============================================

resource "azurerm_private_endpoint" "automation_account" {
  name                = "pe-${var.mgmt_automation_account_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.automation_account.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_automation_account_name}"
    private_connection_resource_id = azurerm_automation_account.this.id
    subresource_names              = ["DSCAndHybridWorker"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.azure-automation.net"]]
  }

  tags = var.tags
}

# ============================================
# Private Endpoint - Recovery Services Vault
# ============================================

resource "azurerm_private_endpoint" "recovery_services_vault" {
  name                = "pe-${var.mgmt_recovery_services_vault_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.recovery_services_vault.name
  subnet_id           = data.terraform_remote_state.management_network_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]

  private_service_connection {
    name                           = "psc-${var.mgmt_recovery_services_vault_name}"
    private_connection_resource_id = azurerm_recovery_services_vault.this.id
    subresource_names              = ["AzureBackup"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.eus2.backup.windowsazure.com"],
      data.terraform_remote_state.identity_network_1.outputs.private_dns_zone_ids["privatelink.blob.core.windows.net"]
    ]
  }

  tags = var.tags
}

# ============================================
# Diagnostic Settings - Automation Account
# ============================================

resource "azurerm_monitor_diagnostic_setting" "automation_account" {
  name                       = "diag-${var.mgmt_automation_account_name}"
  target_resource_id         = azurerm_automation_account.this.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

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

  enabled_metric {
    category = "AllMetrics"
  }
}

# ============================================
# Diagnostic Settings - Recovery Services Vault
# ============================================

resource "azurerm_monitor_diagnostic_setting" "recovery_services_vault" {
  name                       = "diag-${var.mgmt_recovery_services_vault_name}"
  target_resource_id         = azurerm_recovery_services_vault.this.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "CoreAzureBackup"
  }

  enabled_log {
    category = "AddonAzureBackupJobs"
  }

  enabled_log {
    category = "AddonAzureBackupPolicy"
  }

  enabled_log {
    category = "AddonAzureBackupProtectedInstance"
  }

  enabled_log {
    category = "AddonAzureBackupStorage"
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

  enabled_metric {
    category = "AllMetrics"
  }
}

# ============================================
# Diagnostic Settings - Storage Account VM
# ============================================

resource "azurerm_monitor_diagnostic_setting" "storage_vm" {
  name                       = "diag-${var.mgmt_storage_account_vm_name}"
  target_resource_id         = azurerm_storage_account.vm.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage_vm_blob" {
  name                       = "diag-${var.mgmt_storage_account_vm_name}-blob"
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

# ============================================
# Diagnostic Settings - Storage Account NTWK
# ============================================

resource "azurerm_monitor_diagnostic_setting" "storage_ntwk" {
  name                       = "diag-${var.mgmt_storage_account_ntwk_name}"
  target_resource_id         = azurerm_storage_account.ntwk.id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "storage_ntwk_blob" {
  name                       = "diag-${var.mgmt_storage_account_ntwk_name}-blob"
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

# ============================================
# Diagnostic Settings - Key Vaults from Tools Deployment 1
# ============================================

resource "azurerm_monitor_diagnostic_setting" "key_vault_prd" {
  name                       = "diag-${var.mgmt_key_vault_prd_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_1.outputs.key_vault_prd_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "key_vault_nprd" {
  name                       = "diag-${var.mgmt_key_vault_nprd_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_1.outputs.key_vault_nprd_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# ============================================
# Diagnostic Settings - Log Analytics Workspace from Tools Deployment 1
# ============================================

resource "azurerm_monitor_diagnostic_setting" "log_analytics" {
  name                       = "diag-${var.mgmt_log_analytics_workspace_name}"
  target_resource_id         = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id
  log_analytics_workspace_id = data.terraform_remote_state.management_tools_1.outputs.log_analytics_workspace_id

  enabled_log {
    category = "Audit"
  }

  enabled_log {
    category = "SummaryLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}