#--------------------------------------------------------------
# Provider Variables
#--------------------------------------------------------------

variable "subscription_id" {
  description = "The Azure subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    subscription  = "identity"
    deployed_by   = "Terraform"
  }
}

#--------------------------------------------------------------
# Resource Group Names
#--------------------------------------------------------------

variable "rsv_resource_group_name" {
  description = "Name of the resource group for Recovery Services Vault"
  type        = string
  default     = "rg-rsv-prd-idm-wus3-01"
}

variable "storage_resource_group_name" {
  description = "Name of the resource group for Storage Accounts"
  type        = string
  default     = "rg-st-prd-idm-wus3-01"
}

#--------------------------------------------------------------
# Recovery Services Vault Variables
#--------------------------------------------------------------

variable "rsv_name" {
  description = "Name of the Recovery Services Vault"
  type        = string
  default     = "rsv-idm-prd-wus3-01"
}

variable "rsv_sku" {
  description = "SKU for the Recovery Services Vault"
  type        = string
  default     = "Standard"
}

variable "rsv_soft_delete_enabled" {
  description = "Enable soft delete for the Recovery Services Vault"
  type        = bool
  default     = true
}

variable "rsv_storage_mode_type" {
  description = "Storage mode type for the Recovery Services Vault"
  type        = string
  default     = "GeoRedundant"
}

variable "rsv_cross_region_restore_enabled" {
  description = "Enable cross region restore for the Recovery Services Vault"
  type        = bool
  default     = false
}

variable "rsv_public_network_access_enabled" {
  description = "Enable public network access for the Recovery Services Vault"
  type        = bool
  default     = false
}

#--------------------------------------------------------------
# Storage Account Variables
#--------------------------------------------------------------

variable "storage_account_vm_name" {
  description = "Name of the VM diagnostics storage account"
  type        = string
  default     = "saclouidmvmprdwus301"
}

variable "storage_account_ntwk_name" {
  description = "Name of the network diagnostics storage account"
  type        = string
  default     = "saclouidmntwkprdwus301"
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "GRS"
}

variable "storage_account_kind" {
  description = "Storage account kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_min_tls_version" {
  description = "Minimum TLS version for storage accounts"
  type        = string
  default     = "TLS1_2"
}

variable "storage_enable_https_traffic_only" {
  description = "Enable HTTPS traffic only for storage accounts"
  type        = bool
  default     = true
}

variable "storage_public_network_access_enabled" {
  description = "Enable public network access for storage accounts"
  type        = bool
  default     = false
}

variable "storage_allow_nested_items_public" {
  description = "Allow nested items to be public in storage accounts"
  type        = bool
  default     = false
}

variable "storage_shared_access_key_enabled" {
  description = "Enable shared access key for storage accounts"
  type        = bool
  default     = true
}

variable "storage_blob_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 90
}

variable "storage_container_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 90
}

#--------------------------------------------------------------
# Remote State Variables
#--------------------------------------------------------------

variable "remote_state_resource_group_name" {
  description = "Resource group name for remote state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "remote_state_storage_account_name" {
  description = "Storage account name for remote state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "remote_state_container_name" {
  description = "Container name for remote state"
  type        = string
  default     = "tfstate"
}

variable "identity_network_state_key" {
  description = "State file key for identity network deployment"
  type        = string
  default     = "hub-spoke-primary/identity/network-deployment-1.tfstate"
}

variable "management_tools_state_key" {
  description = "State file key for management tools deployment"
  type        = string
  default     = "hub-spoke-primary/management/tools-deployment-1.tfstate"
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
