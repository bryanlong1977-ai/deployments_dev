#--------------------------------------------------------------
# Subscription Variables
#--------------------------------------------------------------
variable "subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "identity_subscription_id" {
  description = "The subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "connectivity_subscription_id" {
  description = "The subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

#--------------------------------------------------------------
# General Variables
#--------------------------------------------------------------
variable "region" {
  description = "The Azure region for resources"
  type        = string
  default     = "eastus2"
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

variable "environment" {
  description = "The environment name for tagging"
  type        = string
  default     = "Production"
}

variable "deployment_id" {
  description = "The unique deployment identifier"
  type        = string
  default     = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
}

#--------------------------------------------------------------
# VNet Variables
#--------------------------------------------------------------
variable "vnet_name" {
  description = "The name of the Management VNet"
  type        = string
  default     = "vnet-mgmt-prd-eus2-01"
}

variable "vnet_resource_group_name" {
  description = "The resource group name for the Management VNet"
  type        = string
  default     = "rg-network-prd-mgmt-eus2-01"
}

#--------------------------------------------------------------
# Network Watcher Variables
#--------------------------------------------------------------
variable "network_watcher_name" {
  description = "The name of the Network Watcher"
  type        = string
  default     = "nw-mgmt-prd-eus2-01"
}

variable "network_watcher_resource_group_name" {
  description = "The resource group name for the Network Watcher"
  type        = string
  default     = "rg-nw-prd-mgmt-eus2-01"
}

#--------------------------------------------------------------
# Diagnostic Settings Variables
#--------------------------------------------------------------
variable "vnet_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for the VNet"
  type        = string
  default     = "diag-vnet-mgmt-prd-eus2-01"
}

variable "enable_metrics" {
  description = "Enable metrics collection for diagnostic settings"
  type        = bool
  default     = true
}

#--------------------------------------------------------------
# DNS Variables
#--------------------------------------------------------------
variable "dns_ruleset_vnet_link_name" {
  description = "The name of the DNS forwarding ruleset VNet link"
  type        = string
  default     = "vnetlink-mgmt-prd-eus2-01"
}

variable "dns_zone_link_prefix" {
  description = "The prefix for DNS zone VNet link names"
  type        = string
  default     = "pdnslink-mgmt"
}

variable "dns_zone_auto_registration_enabled" {
  description = "Enable auto registration for DNS zone VNet links"
  type        = bool
  default     = false
}

variable "private_dns_zones" {
  description = "List of private DNS zones to link to the Management VNet"
  type        = list(string)
  default = [
    "privatelink.blob.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.siterecovery.windowsazure.com",
    "privatelink.eus2.backup.windowsazure.com",
    "privatelink.cus.backup.windowsazure.com",
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
# Flow Log Variables
#--------------------------------------------------------------
variable "vnet_flow_log_name" {
  description = "The name of the VNet flow log"
  type        = string
  default     = "fl-vnet-mgmt-prd-eus2-01"
}

variable "flow_log_enabled" {
  description = "Enable VNet flow logging"
  type        = bool
  default     = true
}

variable "flow_log_version" {
  description = "The version of the flow log format"
  type        = number
  default     = 2
}

variable "flow_log_retention_enabled" {
  description = "Enable retention policy for flow logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "Number of days to retain flow logs"
  type        = number
  default     = 90
}

variable "traffic_analytics_enabled" {
  description = "Enable traffic analytics for flow logs"
  type        = bool
  default     = true
}

variable "traffic_analytics_interval_minutes" {
  description = "The interval in minutes for traffic analytics processing"
  type        = number
  default     = 10

  validation {
    condition     = contains([10, 60], var.traffic_analytics_interval_minutes)
    error_message = "Traffic analytics interval must be 10 or 60 minutes."
  }
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
