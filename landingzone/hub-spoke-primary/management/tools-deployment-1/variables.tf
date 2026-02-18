variable "subscription_id" {
  description = "The subscription ID where resources will be deployed"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    managed_by    = "Terraform"
  }
}

# Resource Group Names
variable "key_vault_resource_group_name" {
  description = "Name of the resource group for Key Vault"
  type        = string
  default     = "rg-kv-prd-mgmt-eus2-01"
}

variable "log_analytics_resource_group_name" {
  description = "Name of the resource group for Log Analytics Workspace"
  type        = string
  default     = "rg-log-prd-mgmt-eus2-01"
}

variable "managed_identity_resource_group_name" {
  description = "Name of the resource group for Managed Identity"
  type        = string
  default     = "rg-mi-prd-mgmt-eus2-01"
}

# Log Analytics Workspace Variables
variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
  default     = "law-mgmt-prd-eus2-01"
}

variable "log_analytics_sku" {
  description = "SKU of the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_days" {
  description = "Retention period in days for Log Analytics Workspace"
  type        = number
  default     = 90
}

variable "log_analytics_daily_quota_gb" {
  description = "Daily quota in GB for Log Analytics Workspace (-1 for unlimited)"
  type        = number
  default     = -1
}

# Managed Identity Variables
variable "managed_identity_name" {
  description = "Name of the User Assigned Managed Identity"
  type        = string
  default     = "mi-mgmt-prd-eus2-01"
}

# Key Vault Variables
variable "key_vault_prd_name" {
  description = "Name of the Production Key Vault"
  type        = string
  default     = "kvcloumgmtprdeus201"
}

variable "key_vault_nprd_name" {
  description = "Name of the Non-Production Key Vault"
  type        = string
  default     = "kvcloumgmtnprdeus201"
}

variable "key_vault_sku" {
  description = "SKU of the Key Vault"
  type        = string
  default     = "standard"
}

variable "key_vault_soft_delete_retention_days" {
  description = "Soft delete retention days for Key Vault"
  type        = number
  default     = 90
}

variable "key_vault_purge_protection_enabled" {
  description = "Enable purge protection for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_rbac_authorization_enabled" {
  description = "Enable RBAC authorization for Key Vault"
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_deployment" {
  description = "Enable Key Vault for VM deployment"
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_disk_encryption" {
  description = "Enable Key Vault for disk encryption"
  type        = bool
  default     = true
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Enable Key Vault for template deployment"
  type        = bool
  default     = true
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
}

variable "key_vault_network_acls_bypass" {
  description = "Bypass setting for Key Vault network ACLs"
  type        = string
  default     = "AzureServices"
}

# Private Endpoint Variables
variable "key_vault_prd_private_endpoint_name" {
  description = "Name of the private endpoint for Production Key Vault"
  type        = string
  default     = "pep-kv-prd-mgmt-eus2-01"
}

variable "key_vault_nprd_private_endpoint_name" {
  description = "Name of the private endpoint for Non-Production Key Vault"
  type        = string
  default     = "pep-kv-nprd-mgmt-eus2-01"
}

variable "key_vault_prd_private_service_connection_name" {
  description = "Name of the private service connection for Production Key Vault"
  type        = string
  default     = "psc-kv-prd-mgmt-eus2-01"
}

variable "key_vault_nprd_private_service_connection_name" {
  description = "Name of the private service connection for Non-Production Key Vault"
  type        = string
  default     = "psc-kv-nprd-mgmt-eus2-01"
}

variable "key_vault_private_dns_zone_group_name" {
  description = "Name of the private DNS zone group for Key Vault"
  type        = string
  default     = "default"
}

# ============================================
# Standard Landing Zone Variables
# These variables are common across all deployments
# ============================================

variable "customer_name" {
  description = "Customer name for the Landing Zone"
  type        = string
}

variable "project_name" {
  description = "Project name for the Landing Zone"
  type        = string
}

variable "environment" {
  description = "Environment (production, staging, development)"
  type        = string
  default     = "production"
}

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
