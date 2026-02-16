#--------------------------------------------------------------
# Subscription Variables
#--------------------------------------------------------------
variable "subscription_id" {
  description = "The subscription ID for the Management subscription where resources are deployed"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "identity_subscription_id" {
  description = "The subscription ID for the Identity subscription where DNS zones are located"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "connectivity_subscription_id" {
  description = "The subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

#--------------------------------------------------------------
# Common Variables
#--------------------------------------------------------------
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

#--------------------------------------------------------------
# VNet Variables
#--------------------------------------------------------------
variable "vnet_name" {
  description = "The name of the Management VNet"
  type        = string
  default     = "vnet-mgmt-prd-wus3-01"
}

variable "vnet_resource_group_name" {
  description = "The resource group name for the Management VNet"
  type        = string
  default     = "rg-network-prd-mgmt-wus3-01"
}

#--------------------------------------------------------------
# Diagnostic Settings Variables
#--------------------------------------------------------------
variable "vnet_diagnostic_setting_name" {
  description = "The name for the VNet diagnostic setting"
  type        = string
  default     = "diag-vnet-mgmt-prd-wus3-01"
}

variable "enable_metrics" {
  description = "Enable metrics collection for diagnostic settings"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "The number of days to retain logs in Log Analytics"
  type        = number
  default     = 90
}

#--------------------------------------------------------------
# Flow Log Variables
#--------------------------------------------------------------
variable "vnet_flow_log_name" {
  description = "The name for the VNet flow log"
  type        = string
  default     = "fl-vnet-mgmt-prd-wus3-01"
}

variable "enable_flow_logs" {
  description = "Enable VNet flow logs"
  type        = bool
  default     = true
}

variable "flow_log_version" {
  description = "The version of the flow log format (1 or 2)"
  type        = number
  default     = 2

  validation {
    condition     = contains([1, 2], var.flow_log_version)
    error_message = "Flow log version must be 1 or 2."
  }
}

variable "flow_log_retention_enabled" {
  description = "Enable retention policy for flow logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "The number of days to retain flow logs in storage"
  type        = number
  default     = 90

  validation {
    condition     = var.flow_log_retention_days >= 0 && var.flow_log_retention_days <= 365
    error_message = "Flow log retention days must be between 0 and 365."
  }
}

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for flow logs"
  type        = bool
  default     = true
}

variable "traffic_analytics_interval" {
  description = "The interval in minutes for Traffic Analytics processing (10 or 60)"
  type        = number
  default     = 10

  validation {
    condition     = contains([10, 60], var.traffic_analytics_interval)
    error_message = "Traffic analytics interval must be 10 or 60 minutes."
  }
}

#--------------------------------------------------------------
# DNS Zone Link Variables
#--------------------------------------------------------------
variable "dns_resource_group_name" {
  description = "The resource group name where Private DNS Zones are located in the Identity subscription"
  type        = string
  default     = "rg-dns-prd-identity-wus3-01"
}

variable "dns_auto_registration_enabled" {
  description = "Enable auto-registration of VM DNS records in the linked DNS zones"
  type        = bool
  default     = false
}

variable "private_dns_zones" {
  description = "List of Private DNS Zone names to link to the Management VNet"
  type        = list(string)
  default = [
    "privatelink.blob.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.siterecovery.windowsazure.com",
    "privatelink.wus3.backup.windowsazure.com",
    "privatelink.eus.backup.windowsazure.com",
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.azure-automation.net",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.blob.storage.azure.net",
    "privatelink.disk.azure.net"
  ]
}

#--------------------------------------------------------------
# Network Watcher Variables
#--------------------------------------------------------------
variable "network_watcher_name" {
  description = "The name of the Network Watcher"
  type        = string
  default     = "nw-mgmt-prd-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "The resource group name for the Network Watcher"
  type        = string
  default     = "rg-nw-prd-mgmt-wus3-01"
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
