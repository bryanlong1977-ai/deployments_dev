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

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "environment" {
  description = "The environment name (e.g., Production, Development)"
  type        = string
  default     = "Production"
}

variable "customer_name" {
  description = "The customer name for tagging"
  type        = string
  default     = "Cloud AI Consulting"
}

variable "project_name" {
  description = "The project name for tagging"
  type        = string
  default     = "Secure Cloud Foundations"
}

variable "deployment_id" {
  description = "The unique deployment identifier"
  type        = string
  default     = "8b492308-bab3-41e1-a8cb-1348dfea4227"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

# VNet Configuration
variable "vnet_name" {
  description = "The name of the Identity VNet"
  type        = string
  default     = "vnet-idm-prd-wus3-01"
}

variable "vnet_resource_group_name" {
  description = "The resource group name for the Identity VNet"
  type        = string
  default     = "rg-network-prd-idm-wus3-01"
}

# Diagnostic Settings Configuration
variable "vnet_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for the VNet"
  type        = string
  default     = "diag-vnet-idm-prd-wus3-01"
}

variable "diagnostic_retention_days" {
  description = "The number of days to retain diagnostic logs"
  type        = number
  default     = 90
}

variable "enable_metrics" {
  description = "Enable metrics collection for diagnostic settings"
  type        = bool
  default     = true
}

# VNet Flow Log Configuration
variable "vnet_flow_log_name" {
  description = "The name of the VNet flow log"
  type        = string
  default     = "fl-vnet-idm-prd-wus3-01"
}

variable "flow_log_enabled" {
  description = "Enable VNet flow logging"
  type        = bool
  default     = true
}

variable "flow_log_version" {
  description = "The version of flow log format"
  type        = number
  default     = 2
}

variable "flow_log_retention_enabled" {
  description = "Enable retention policy for flow logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "The number of days to retain flow logs"
  type        = number
  default     = 90
}

variable "traffic_analytics_enabled" {
  description = "Enable traffic analytics for flow logs"
  type        = bool
  default     = true
}

variable "traffic_analytics_interval" {
  description = "The interval in minutes for traffic analytics processing"
  type        = number
  default     = 10

  validation {
    condition     = contains([10, 60], var.traffic_analytics_interval)
    error_message = "Traffic analytics interval must be either 10 or 60 minutes."
  }
}

# Network Watcher Configuration
variable "network_watcher_name" {
  description = "The name of the Network Watcher"
  type        = string
  default     = "nw-idm-prd-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "The resource group name for the Network Watcher"
  type        = string
  default     = "rg-nw-prd-idm-wus3-01"
}

# Log Analytics Configuration
variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace in Management subscription"
  type        = string
  default     = "law-mgmt-prd-wus3-01"
}

variable "log_analytics_resource_group_name" {
  description = "The resource group name for the Log Analytics Workspace"
  type        = string
  default     = "rg-log-prd-mgmt-wus3-01"
}

# Storage Account Configuration
variable "network_storage_account_name" {
  description = "The name of the network storage account for flow logs"
  type        = string
  default     = "saclouidmntwkprdwus301"
}

variable "storage_resource_group_name" {
  description = "The resource group name for the storage account"
  type        = string
  default     = "rg-st-prd-idm-wus3-01"
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
