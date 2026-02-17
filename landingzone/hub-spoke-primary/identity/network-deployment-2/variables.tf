# =============================================================================
# Subscription Variables
# =============================================================================

variable "subscription_id" {
  description = "The subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "management_subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

# =============================================================================
# Common Variables
# =============================================================================

variable "customer" {
  description = "Customer name for tagging"
  type        = string
  default     = "Cloud AI Consulting"
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "Secure Cloud Foundations"
}

variable "environment" {
  description = "Environment (Production, Development, etc.)"
  type        = string
  default     = "Production"
}

variable "deployment_id" {
  description = "Unique deployment identifier"
  type        = string
  default     = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
}

variable "region" {
  description = "Primary Azure region for deployment"
  type        = string
  default     = "westus3"
}

variable "management_region" {
  description = "Azure region for Management subscription resources"
  type        = string
  default     = "westus3"
}

# =============================================================================
# Diagnostic Settings Variables
# =============================================================================

variable "vnet_diagnostic_setting_name" {
  description = "Name for the VNet diagnostic setting"
  type        = string
  default     = "diag-vnet-idm-prd-wus3-01"
}

variable "diagnostic_retention_days" {
  description = "Number of days to retain diagnostic logs"
  type        = number
  default     = 90
}

# =============================================================================
# Flow Log Variables
# =============================================================================

variable "vnet_flow_log_name" {
  description = "Name for the VNet flow log"
  type        = string
  default     = "fl-vnet-idm-prd-wus3-01"
}

variable "flow_log_enabled" {
  description = "Enable flow logging"
  type        = bool
  default     = true
}

variable "flow_log_version" {
  description = "Flow log version (1 or 2)"
  type        = number
  default     = 2
}

variable "flow_log_retention_enabled" {
  description = "Enable flow log retention"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "Number of days to retain flow logs"
  type        = number
  default     = 90
}

variable "traffic_analytics_enabled" {
  description = "Enable traffic analytics"
  type        = bool
  default     = true
}

variable "traffic_analytics_interval" {
  description = "Traffic analytics processing interval in minutes (10 or 60)"
  type        = number
  default     = 10

  validation {
    condition     = contains([10, 60], var.traffic_analytics_interval)
    error_message = "Traffic analytics interval must be 10 or 60 minutes."
  }
}

# =============================================================================
# Remote State Configuration Variables
# =============================================================================

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

variable "tfstate_subscription_id" {
  description = "Subscription ID where Terraform state storage resides"
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
