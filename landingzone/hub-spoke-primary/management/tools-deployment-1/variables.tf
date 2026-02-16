# Variables for Tools Deployment 1 - Management Subscription

# ============================================================================
# SUBSCRIPTION AND DEPLOYMENT CONTEXT
# ============================================================================

variable "subscription_id" {
  description = "The Azure subscription ID where resources will be deployed"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "customer_name" {
  description = "Customer name for tagging"
  type        = string
  default     = "Cloud AI Consulting"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "Secure Cloud Foundations"
}

variable "environment" {
  description = "Environment name (Production, Development, etc.)"
  type        = string
  default     = "Production"
}

variable "deployment_id" {
  description = "Unique deployment identifier"
  type        = string
  default     = "8b492308-bab3-41e1-a8cb-1348dfea4227"
}

variable "region" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

# ============================================================================
# RESOURCE GROUP NAMES
# ============================================================================

variable "kv_resource_group_name" {
  description = "Name of the resource group for Key Vaults"
  type        = string
  default     = "rg-kv-prd-mgmt-wus3-01"
}

variable "log_resource_group_name" {
  description = "Name of the resource group for Log Analytics Workspace"
  type        = string
  default     = "rg-log-prd-mgmt-wus3-01"
}

variable "mi_resource_group_name" {
  description = "Name of the resource group for Managed Identity"
  type        = string
  default     = "rg-mi-prd-mgmt-wus3-01"
}

# ============================================================================
# LOG ANALYTICS WORKSPACE
# ============================================================================

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
  default     = "law-mgmt-prd-wus3-01"
}

variable "log_analytics_sku" {
  description = "SKU for the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"

  validation {
    condition     = var.log_analytics_sku == null || contains(["Free", "PerNode", "Premium", "Standard", "Standalone", "Unlimited", "CapacityReservation", "PerGB2018"], var.log_analytics_sku)
    error_message = "Log Analytics SKU must be one of: Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, PerGB2018."
  }
}

variable "log_analytics_retention_days" {
  description = "Retention period in days for Log Analytics Workspace"
  type        = number
  default     = 90

  validation {
    condition     = var.log_analytics_retention_days >= 30 && var.log_analytics_retention_days <= 730
    error_message = "Log Analytics retention must be between 30 and 730 days."
  }
}

variable "log_analytics_internet_ingestion_enabled" {
  description = "Enable internet ingestion for Log Analytics"
  type        = bool
  default     = true
}

variable "log_analytics_internet_query_enabled" {
  description = "Enable internet query for Log Analytics"
  type        = bool
  default     = true
}

# ============================================================================
# MANAGED IDENTITY
# ============================================================================

variable "managed_identity_name" {
  description = "Name of the User Assigned Managed Identity"
  type        = string
  default     = "mi-mgmt-prd-wus3-01"
}

# ============================================================================
# KEY VAULTS
# ============================================================================

variable "key_vault_prd_name" {
  description = "Name of the Production Key Vault"
  type        = string
  default     = "kvcloumgmtprdwus301"
}

variable "key_vault_nprd_name" {
  description = "Name of the Non-Production Key Vault"
  type        = string
  default     = "kvcloumgmtnprdwus301"
}

variable "key_vault_sku" {
  description = "SKU for Key Vault (standard or premium)"
  type        = string
  default     = "standard"

  validation {
    condition     = var.key_vault_sku == null || contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be 'standard' or 'premium'."
  }
}

variable "key_vault_enabled_for_deployment" {
  description = "Enable Key Vault for Azure Virtual Machine deployment"
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_disk_encryption" {
  description = "Enable Key Vault for Azure Disk Encryption"
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Enable Key Vault for ARM template deployment"
  type        = bool
  default     = true
}

variable "key_vault_rbac_authorization_enabled" {
  description = "Enable RBAC authorization for Key Vault (recommended)"
  type        = bool
  default     = true
}

variable "key_vault_purge_protection_enabled" {
  description = "Enable purge protection for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_soft_delete_retention_days" {
  description = "Soft delete retention period in days for Key Vault"
  type        = number
  default     = 90

  validation {
    condition     = var.key_vault_soft_delete_retention_days >= 7 && var.key_vault_soft_delete_retention_days <= 90
    error_message = "Key Vault soft delete retention must be between 7 and 90 days."
  }
}

variable "key_vault_public_network_access_enabled" {
  description = "Enable public network access for Key Vault"
  type        = bool
  default     = false
}

variable "key_vault_network_acls_default_action" {
  description = "Default action for Key Vault network ACLs"
  type        = string
  default     = "Deny"

  validation {
    condition     = var.key_vault_network_acls_default_action == null || contains(["Allow", "Deny"], var.key_vault_network_acls_default_action)
    error_message = "Key Vault network ACLs default action must be 'Allow' or 'Deny'."
  }
}

variable "key_vault_network_acls_bypass" {
  description = "Services that can bypass Key Vault network ACLs"
  type        = string
  default     = "AzureServices"

  validation {
    condition     = var.key_vault_network_acls_bypass == null || contains(["None", "AzureServices"], var.key_vault_network_acls_bypass)
    error_message = "Key Vault network ACLs bypass must be 'None' or 'AzureServices'."
  }
}

# ============================================================================
# PRIVATE ENDPOINT NAMES
# ============================================================================

variable "key_vault_prd_pe_name" {
  description = "Name of the Private Endpoint for Production Key Vault"
  type        = string
  default     = "pe-kvcloumgmtprdwus301"
}

variable "key_vault_nprd_pe_name" {
  description = "Name of the Private Endpoint for Non-Production Key Vault"
  type        = string
  default     = "pe-kvcloumgmtnprdwus301"
}

# ============================================
# Standard Landing Zone Variables
# These variables are common across all deployments
# ============================================

variable "hub_vnet_cidr" {
  description = "CIDR block for the hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_firewall" {
  description = "Enable Azure Firewall in the hub VNet"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway for hybrid connectivity"
  type        = bool
  default     = false
}

variable "enable_bastion" {
  description = "Enable Azure Bastion for secure VM access"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Resource tags to apply to all resources"
  type        = map(string)
  default     = {}
}
