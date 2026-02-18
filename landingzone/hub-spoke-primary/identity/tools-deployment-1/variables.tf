#--------------------------------------------------------------
# Subscription Variables
#--------------------------------------------------------------

variable "subscription_id" {
  description = "The Azure subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "identity_subscription_id" {
  description = "The Azure subscription ID for the Identity subscription (for DNS zones)"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "management_subscription_id" {
  description = "The Azure subscription ID for the Management subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

#--------------------------------------------------------------
# Location Variables
#--------------------------------------------------------------

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

#--------------------------------------------------------------
# Resource Group Variables
#--------------------------------------------------------------

variable "rsv_resource_group_name" {
  description = "Name of the resource group for Recovery Services Vault"
  type        = string
  default     = "rg-rsv-prd-idm-eus2-01"
}

variable "storage_resource_group_name" {
  description = "Name of the resource group for Storage Accounts"
  type        = string
  default     = "rg-st-prd-idm-eus2-01"
}

#--------------------------------------------------------------
# Recovery Services Vault Variables
#--------------------------------------------------------------

variable "rsv_name" {
  description = "Name of the Recovery Services Vault"
  type        = string
  default     = "rsv-idm-prd-eus2-01"
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

  validation {
    condition     = var.rsv_storage_mode_type == null || contains(["GeoRedundant", "LocallyRedundant", "ZoneRedundant"], var.rsv_storage_mode_type)
    error_message = "Storage mode type must be GeoRedundant, LocallyRedundant, or ZoneRedundant."
  }
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
  default     = "saclouidmvmprdeus201"
}

variable "storage_account_ntwk_name" {
  description = "Name of the network diagnostics storage account"
  type        = string
  default     = "saclouidmntwkprdeus201"
}

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"

  validation {
    condition     = var.storage_account_tier == null || contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "Storage account tier must be Standard or Premium."
  }
}

variable "storage_account_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "GRS"

  validation {
    condition     = var.storage_account_replication_type == null || contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "Storage account replication type must be LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "storage_account_kind" {
  description = "Storage account kind"
  type        = string
  default     = "StorageV2"

  validation {
    condition     = var.storage_account_kind == null || contains(["Storage", "StorageV2", "BlobStorage", "BlockBlobStorage", "FileStorage"], var.storage_account_kind)
    error_message = "Storage account kind must be Storage, StorageV2, BlobStorage, BlockBlobStorage, or FileStorage."
  }
}

variable "storage_min_tls_version" {
  description = "Minimum TLS version for storage account"
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = var.storage_min_tls_version == null || contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.storage_min_tls_version)
    error_message = "Minimum TLS version must be TLS1_0, TLS1_1, or TLS1_2."
  }
}

variable "storage_https_only" {
  description = "Enable HTTPS only traffic for storage account"
  type        = bool
  default     = true
}

variable "storage_public_network_access_enabled" {
  description = "Enable public network access for storage account"
  type        = bool
  default     = false
}

variable "storage_allow_nested_items_public" {
  description = "Allow nested items to be public in storage account"
  type        = bool
  default     = false
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
# Diagnostic Settings Variables
#--------------------------------------------------------------

variable "diagnostic_retention_days" {
  description = "Number of days to retain diagnostic logs"
  type        = number
  default     = 90
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
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    subscription  = "identity"
    deployed_by   = "terraform"
  }
}

#--------------------------------------------------------------
# Remote State Variables
#--------------------------------------------------------------

variable "tfstate_resource_group_name" {
  description = "Resource group name for Terraform state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "tfstate_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "tfstate_container_name" {
  description = "Container name for Terraform state"
  type        = string
  default     = "tfstate"
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
