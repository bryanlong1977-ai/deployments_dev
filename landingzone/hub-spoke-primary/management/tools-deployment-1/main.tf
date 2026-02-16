# Terraform configuration for Tools Deployment 1 - Management Subscription
# Resources: Key Vault, Log Analytics Workspace, Managed Identity

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
  features {}
  subscription_id = var.subscription_id
}

# Local values for consistent tagging and naming
locals {
  common_tags = {
    customer      = var.customer_name
    project       = var.project_name
    environment   = var.environment
    deployment_id = var.deployment_id
    deployed_by   = "terraform"
    deployment    = "tools-deployment-1"
  }
}

# ============================================================================
# RESOURCE GROUPS
# ============================================================================

# Resource Group for Key Vaults
resource "azurerm_resource_group" "kv" {
  name     = var.kv_resource_group_name
  location = var.region
  tags     = local.common_tags
}

# Resource Group for Log Analytics Workspace
resource "azurerm_resource_group" "log" {
  name     = var.log_resource_group_name
  location = var.region
  tags     = local.common_tags
}

# Resource Group for Managed Identity
resource "azurerm_resource_group" "mi" {
  name     = var.mi_resource_group_name
  location = var.region
  tags     = local.common_tags
}

# ============================================================================
# LOG ANALYTICS WORKSPACE
# ============================================================================

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.log.location
  resource_group_name = azurerm_resource_group.log.name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days

  # Enable internet ingestion and query for management operations
  internet_ingestion_enabled = var.log_analytics_internet_ingestion_enabled
  internet_query_enabled     = var.log_analytics_internet_query_enabled

  tags = local.common_tags
}

# ============================================================================
# MANAGED IDENTITY
# ============================================================================

resource "azurerm_user_assigned_identity" "main" {
  name                = var.managed_identity_name
  location            = azurerm_resource_group.mi.location
  resource_group_name = azurerm_resource_group.mi.name
  tags                = local.common_tags
}

# ============================================================================
# KEY VAULTS
# ============================================================================

# Get current client configuration for tenant ID
data "azurerm_client_config" "current" {}

# Production Key Vault
resource "azurerm_key_vault" "prd" {
  name                = var.key_vault_prd_name
  location            = azurerm_resource_group.kv.location
  resource_group_name = azurerm_resource_group.kv.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku

  # Security settings
  enabled_for_deployment          = var.key_vault_enabled_for_deployment
  enabled_for_disk_encryption     = var.key_vault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  rbac_authorization_enabled       = var.key_vault_rbac_authorization_enabled
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  public_network_access_enabled   = var.key_vault_public_network_access_enabled

  network_acls {
    default_action = var.key_vault_network_acls_default_action
    bypass         = var.key_vault_network_acls_bypass
  }

  tags = merge(local.common_tags, {
    key_vault_environment = "prd"
  })
}

# Non-Production Key Vault
resource "azurerm_key_vault" "nprd" {
  name                = var.key_vault_nprd_name
  location            = azurerm_resource_group.kv.location
  resource_group_name = azurerm_resource_group.kv.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.key_vault_sku

  # Security settings
  enabled_for_deployment          = var.key_vault_enabled_for_deployment
  enabled_for_disk_encryption     = var.key_vault_enabled_for_disk_encryption
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  rbac_authorization_enabled       = var.key_vault_rbac_authorization_enabled
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  public_network_access_enabled   = var.key_vault_public_network_access_enabled

  network_acls {
    default_action = var.key_vault_network_acls_default_action
    bypass         = var.key_vault_network_acls_bypass
  }

  tags = merge(local.common_tags, {
    key_vault_environment = "nprd"
  })
}

# ============================================================================
# KEY VAULT PRIVATE ENDPOINTS
# ============================================================================

# Private Endpoint for Production Key Vault
resource "azurerm_private_endpoint" "kv_prd" {
  name                = var.key_vault_prd_pe_name
  location            = azurerm_resource_group.kv.location
  resource_group_name = azurerm_resource_group.kv.name
  subnet_id           = data.terraform_remote_state.management_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.key_vault_prd_name}"
    private_connection_resource_id = azurerm_key_vault.prd.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.vaultcore.azure.net"]]
  }

  tags = merge(local.common_tags, {
    resource = var.key_vault_prd_name
  })
}

# Private Endpoint for Non-Production Key Vault
resource "azurerm_private_endpoint" "kv_nprd" {
  name                = var.key_vault_nprd_pe_name
  location            = azurerm_resource_group.kv.location
  resource_group_name = azurerm_resource_group.kv.name
  subnet_id           = data.terraform_remote_state.management_network_deployment_1.outputs.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.key_vault_nprd_name}"
    private_connection_resource_id = azurerm_key_vault.nprd.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [data.terraform_remote_state.identity_network_deployment_1.outputs.private_dns_zone_ids["privatelink.vaultcore.azure.net"]]
  }

  tags = merge(local.common_tags, {
    resource = var.key_vault_nprd_name
  })
}