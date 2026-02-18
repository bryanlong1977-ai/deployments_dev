# Subscription variables
variable "subscription_id" {
  description = "The subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "management_subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

# Project metadata variables
variable "customer_name" {
  description = "Name of the customer"
  type        = string
  default     = "Cloud AI Consulting"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "Secure Cloud Foundations"
}

variable "environment" {
  description = "Environment name (Production, Development, etc.)"
  type        = string
  default     = "Production"
}

variable "deployment_id" {
  description = "Unique identifier for this deployment"
  type        = string
  default     = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
}

variable "region" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Network resource names
variable "vnet_name" {
  description = "Name of the Identity VNet"
  type        = string
  default     = "vnet-idm-prd-eus2-01"
}

variable "network_resource_group_name" {
  description = "Name of the network resource group in Identity subscription"
  type        = string
  default     = "rg-network-prd-idm-eus2-01"
}

# Diagnostic settings variables
variable "vnet_diagnostic_setting_name" {
  description = "Name for the VNet diagnostic setting"
  type        = string
  default     = "diag-vnet-idm-prd-eus2-01"
}

variable "diagnostic_retention_days" {
  description = "Number of days to retain diagnostic logs"
  type        = number
  default     = 90
}

# Flow log variables
variable "vnet_flow_log_name" {
  description = "Name for the VNet flow log"
  type        = string
  default     = "fl-vnet-idm-prd-eus2-01"
}

variable "flow_log_enabled" {
  description = "Whether flow logging is enabled"
  type        = bool
  default     = true
}

variable "flow_log_version" {
  description = "Version of the flow log format (1 or 2)"
  type        = number
  default     = 2
}

variable "flow_log_retention_enabled" {
  description = "Whether retention policy is enabled for flow logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "Number of days to retain flow logs"
  type        = number
  default     = 90
}

variable "traffic_analytics_enabled" {
  description = "Whether traffic analytics is enabled"
  type        = bool
  default     = true
}

variable "traffic_analytics_interval_minutes" {
  description = "Interval in minutes for traffic analytics processing (10 or 60)"
  type        = number
  default     = 10

  validation {
    condition     = contains([10, 60], var.traffic_analytics_interval_minutes)
    error_message = "Traffic analytics interval must be either 10 or 60 minutes."
  }
}

# Remote state configuration variables
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
  description = "Subscription ID where Terraform state storage is located"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
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
