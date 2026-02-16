# =============================================================================
# Subscription Variables
# =============================================================================

variable "subscription_id" {
  description = "The subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "management_subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "identity_subscription_id" {
  description = "The subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

# =============================================================================
# Region Variables
# =============================================================================

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

# =============================================================================
# Tags Variables
# =============================================================================

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    deployed_by   = "Terraform"
  }
}

# =============================================================================
# Resource Group Variables
# =============================================================================

variable "ampls_resource_group_name" {
  description = "The name of the resource group for Azure Monitor Private Link Scope"
  type        = string
  default     = "rg-mpls-prd-hub-wus3-01"
}

variable "storage_resource_group_name" {
  description = "The name of the resource group for Storage Accounts"
  type        = string
  default     = "rg-st-prd-hub-wus3-01"
}

# =============================================================================
# Azure Monitor Private Link Scope Variables
# =============================================================================

variable "ampls_name" {
  description = "The name of the Azure Monitor Private Link Scope"
  type        = string
  default     = "ampls-hub-prd-wus3-01"
}

variable "ampls_ingestion_access_mode" {
  description = "The ingestion access mode for AMPLS (Open or PrivateOnly)"
  type        = string
  default     = "PrivateOnly"

  validation {
    condition     = contains(["Open", "PrivateOnly"], var.ampls_ingestion_access_mode)
    error_message = "The ingestion access mode must be either 'Open' or 'PrivateOnly'."
  }
}

variable "ampls_query_access_mode" {
  description = "The query access mode for AMPLS (Open or PrivateOnly)"
  type        = string
  default     = "PrivateOnly"

  validation {
    condition     = contains(["Open", "PrivateOnly"], var.ampls_query_access_mode)
    error_message = "The query access mode must be either 'Open' or 'PrivateOnly'."
  }
}

# =============================================================================
# Storage Account Variables
# =============================================================================

variable "storage_account_vm_name" {
  description = "The name of the VM storage account"
  type        = string
  default     = "saclouhubvmprdwus301"
}

variable "storage_account_ntwk_name" {
  description = "The name of the network storage account"
  type        = string
  default     = "saclouhubntwkprdwus301"
}

variable "storage_account_tier" {
  description = "The storage account tier"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The storage account tier must be either 'Standard' or 'Premium'."
  }
}

variable "storage_account_replication_type" {
  description = "The storage account replication type"
  type        = string
  default     = "GRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "The storage account replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "storage_account_kind" {
  description = "The storage account kind"
  type        = string
  default     = "StorageV2"

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.storage_account_kind)
    error_message = "The storage account kind must be one of: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2."
  }
}

variable "storage_min_tls_version" {
  description = "The minimum TLS version for the storage account"
  type        = string
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.storage_min_tls_version)
    error_message = "The minimum TLS version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "storage_allow_nested_items_to_be_public" {
  description = "Allow nested items within the storage account to be public"
  type        = bool
  default     = false
}

variable "storage_public_network_access_enabled" {
  description = "Enable public network access to the storage account"
  type        = bool
  default     = false
}

variable "storage_blob_delete_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 90

  validation {
    condition     = var.storage_blob_delete_retention_days >= 1 && var.storage_blob_delete_retention_days <= 365
    error_message = "Blob delete retention days must be between 1 and 365."
  }
}

variable "storage_container_delete_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 90

  validation {
    condition     = var.storage_container_delete_retention_days >= 1 && var.storage_container_delete_retention_days <= 365
    error_message = "Container delete retention days must be between 1 and 365."
  }
}

variable "diagnostic_retention_days" {
  description = "Number of days to retain diagnostic logs"
  type        = number
  default     = 90

  validation {
    condition     = var.diagnostic_retention_days >= 0 && var.diagnostic_retention_days <= 365
    error_message = "Diagnostic retention days must be between 0 and 365."
  }
}

# =============================================================================
# Remote State Variables
# =============================================================================

variable "tfstate_resource_group_name" {
  description = "The name of the resource group containing the Terraform state storage account"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "tfstate_storage_account_name" {
  description = "The name of the Terraform state storage account"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "tfstate_container_name" {
  description = "The name of the Terraform state container"
  type        = string
  default     = "tfstate"
}

variable "tfstate_subscription_id" {
  description = "The subscription ID for the Terraform state storage account"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
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
