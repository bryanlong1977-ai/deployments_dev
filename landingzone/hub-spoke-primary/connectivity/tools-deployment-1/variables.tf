#--------------------------------------------------------------
# Subscription Variables
#--------------------------------------------------------------

variable "subscription_id" {
  description = "The subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "management_subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "identity_subscription_id" {
  description = "The subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

#--------------------------------------------------------------
# General Variables
#--------------------------------------------------------------

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

#--------------------------------------------------------------
# Azure Monitor Private Link Scope Variables
#--------------------------------------------------------------

variable "ampls_name" {
  description = "Name of the Azure Monitor Private Link Scope"
  type        = string
  default     = "ampls-hub-prd-eus2-01"
}

variable "ampls_resource_group_name" {
  description = "Name of the resource group for AMPLS"
  type        = string
  default     = "rg-mpls-prd-hub-eus2-01"
}

variable "ampls_private_endpoint_name" {
  description = "Name of the private endpoint for AMPLS"
  type        = string
  default     = "pep-ampls-hub-prd-eus2-01"
}

variable "ampls_ingestion_access_mode" {
  description = "The default ingestion access mode for the AMPLS"
  type        = string
  default     = "PrivateOnly"
  validation {
    condition     = contains(["Open", "PrivateOnly"], var.ampls_ingestion_access_mode)
    error_message = "The ampls_ingestion_access_mode must be either 'Open' or 'PrivateOnly'."
  }
}

variable "ampls_query_access_mode" {
  description = "The default query access mode for the AMPLS"
  type        = string
  default     = "PrivateOnly"
  validation {
    condition     = contains(["Open", "PrivateOnly"], var.ampls_query_access_mode)
    error_message = "The ampls_query_access_mode must be either 'Open' or 'PrivateOnly'."
  }
}

#--------------------------------------------------------------
# Storage Account Variables
#--------------------------------------------------------------

variable "storage_resource_group_name" {
  description = "Name of the resource group for storage accounts"
  type        = string
  default     = "rg-st-prd-hub-eus2-01"
}

variable "vm_storage_account_name" {
  description = "Name of the VM diagnostics storage account"
  type        = string
  default     = "saclouhubvmprdeus201"
}

variable "ntwk_storage_account_name" {
  description = "Name of the network diagnostics storage account"
  type        = string
  default     = "saclouhubntwkprdeus201"
}

variable "storage_account_tier" {
  description = "The tier of the storage account"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "The storage_account_tier must be either 'Standard' or 'Premium'."
  }
}

variable "storage_account_replication_type" {
  description = "The replication type for the storage account"
  type        = string
  default     = "GRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "The storage_account_replication_type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "storage_account_kind" {
  description = "The kind of storage account"
  type        = string
  default     = "StorageV2"
  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.storage_account_kind)
    error_message = "The storage_account_kind must be one of: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2."
  }
}

variable "storage_min_tls_version" {
  description = "The minimum TLS version for the storage account"
  type        = string
  default     = "TLS1_2"
  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.storage_min_tls_version)
    error_message = "The storage_min_tls_version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "storage_public_network_access_enabled" {
  description = "Whether public network access is enabled for the storage account"
  type        = bool
  default     = false
}

variable "storage_allow_nested_items_to_be_public" {
  description = "Whether nested items can be public in the storage account"
  type        = bool
  default     = false
}

variable "storage_shared_access_key_enabled" {
  description = "Whether shared access keys are enabled for the storage account"
  type        = bool
  default     = true
}

variable "storage_blob_delete_retention_days" {
  description = "Number of days to retain deleted blobs"
  type        = number
  default     = 90
  validation {
    condition     = var.storage_blob_delete_retention_days >= 1 && var.storage_blob_delete_retention_days <= 365
    error_message = "The storage_blob_delete_retention_days must be between 1 and 365."
  }
}

variable "storage_container_delete_retention_days" {
  description = "Number of days to retain deleted containers"
  type        = number
  default     = 90
  validation {
    condition     = var.storage_container_delete_retention_days >= 1 && var.storage_container_delete_retention_days <= 365
    error_message = "The storage_container_delete_retention_days must be between 1 and 365."
  }
}

variable "storage_network_default_action" {
  description = "The default action for storage account network rules"
  type        = string
  default     = "Deny"
  validation {
    condition     = contains(["Allow", "Deny"], var.storage_network_default_action)
    error_message = "The storage_network_default_action must be either 'Allow' or 'Deny'."
  }
}

variable "storage_network_bypass" {
  description = "Services to bypass the network rules for storage account"
  type        = list(string)
  default     = ["AzureServices", "Logging", "Metrics"]
}

#--------------------------------------------------------------
# Private Endpoint Subnet Variables
#--------------------------------------------------------------

variable "pe_subnet_name" {
  description = "Name of the private endpoint subnet"
  type        = string
  default     = "snet-pe-hub-eus2-01"
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
