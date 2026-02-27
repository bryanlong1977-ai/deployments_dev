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

# Get current client configuration for Key Vault tenant_id
data "azurerm_client_config" "this" {}

# ============================================
# Resource Groups
# ============================================

# Resource Group for Key Vaults
resource "azurerm_resource_group" "kv" {
  name     = var.mgmt_key_vault_prd_resource_group
  location = var.region
  tags     = var.tags
}

# Resource Group for Log Analytics Workspace
resource "azurerm_resource_group" "log" {
  name     = var.mgmt_log_analytics_workspace_resource_group
  location = var.region
  tags     = var.tags
}

# Resource Group for Managed Identity
resource "azurerm_resource_group" "mi" {
  name     = var.mgmt_managed_identity_resource_group
  location = var.region
  tags     = var.tags
}

# ============================================
# Log Analytics Workspace
# ============================================

resource "azurerm_log_analytics_workspace" "this" {
  name                          = var.mgmt_log_analytics_workspace_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.log.name
  sku                           = var.log_analytics_sku
  retention_in_days             = var.log_analytics_retention_days
  local_authentication_enabled  = false
  internet_ingestion_enabled    = false
  internet_query_enabled        = false
  tags                          = var.tags
}

# ============================================
# Key Vault - Production
# ============================================

resource "azurerm_key_vault" "prd" {
  name                          = var.mgmt_key_vault_prd_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.kv.name
  tenant_id                     = data.azurerm_client_config.this.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 90
  purge_protection_enabled      = true
  rbac_authorization_enabled    = true
  enabled_for_disk_encryption   = false
  enabled_for_template_deployment = false
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# ============================================
# Key Vault - Non-Production
# ============================================

resource "azurerm_key_vault" "nprd" {
  name                          = var.mgmt_key_vault_nprd_name
  location                      = var.region
  resource_group_name           = azurerm_resource_group.kv.name
  tenant_id                     = data.azurerm_client_config.this.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 90
  purge_protection_enabled      = true
  rbac_authorization_enabled    = true
  enabled_for_disk_encryption   = false
  enabled_for_template_deployment = false
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# ============================================
# Private Endpoints for Key Vaults
# ============================================

resource "azurerm_private_endpoint" "kv_prd" {
  name                = "pep-${var.mgmt_key_vault_prd_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.kv.name
  subnet_id           = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.mgmt_key_vault_prd_name}"
    private_connection_resource_id = azurerm_key_vault.prd.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids[var.keyvault_dns_zone_name]
    ]
  }
}

resource "azurerm_private_endpoint" "kv_nprd" {
  name                = "pep-${var.mgmt_key_vault_nprd_name}"
  location            = var.region
  resource_group_name = azurerm_resource_group.kv.name
  subnet_id           = data.terraform_remote_state.management_network_deployment_1.outputs.subnet_ids[var.snet_pe_mgmt_eus2_01_subnet_name]
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.mgmt_key_vault_nprd_name}"
    private_connection_resource_id = azurerm_key_vault.nprd.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids[var.keyvault_dns_zone_name]
    ]
  }
}

# ============================================
# Managed Identity
# ============================================

resource "azurerm_user_assigned_identity" "this" {
  name                = var.mgmt_managed_identity_name
  location            = var.region
  resource_group_name = azurerm_resource_group.mi.name
  tags                = var.tags
}