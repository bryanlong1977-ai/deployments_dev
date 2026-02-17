#--------------------------------------------------------------
# Provider Variables
#--------------------------------------------------------------

variable "subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
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
  default     = "westus3"
}

variable "environment" {
  description = "The environment name"
  type        = string
  default     = "Production"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    managed_by    = "Terraform"
  }
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
  description = "Name for the VNet diagnostic setting"
  type        = string
  default     = "diag-vnet-mgmt-prd-wus3-01"
}

variable "diagnostic_retention_days" {
  description = "Number of days to retain diagnostic logs"
  type        = number
  default     = 90
}

variable "enable_metrics" {
  description = "Enable metrics collection for diagnostic settings"
  type        = bool
  default     = true
}

#--------------------------------------------------------------
# DNS Variables
#--------------------------------------------------------------

variable "dns_resource_group_name" {
  description = "The resource group name for DNS resources in Identity subscription"
  type        = string
  default     = "rg-dns-prd-identity-wus3-01"
}

variable "dns_registration_enabled" {
  description = "Enable auto-registration for DNS zone virtual network links"
  type        = bool
  default     = false
}

variable "dns_resolver_vnet_link_name" {
  description = "Name for the DNS resolver virtual network link"
  type        = string
  default     = "vnetlink-mgmt-dns-resolver"
}

variable "private_dns_zones" {
  description = "Map of private DNS zones to link to the VNet"
  type        = map(string)
  default = {
    blob              = "privatelink.blob.core.windows.net"
    queue             = "privatelink.queue.core.windows.net"
    file              = "privatelink.file.core.windows.net"
    table             = "privatelink.table.core.windows.net"
    vault             = "privatelink.vaultcore.azure.net"
    siterecovery      = "privatelink.siterecovery.windowsazure.com"
    backup_wus3       = "privatelink.wus3.backup.windowsazure.com"
    backup_eus        = "privatelink.eus.backup.windowsazure.com"
    monitor           = "privatelink.monitor.azure.com"
    oms               = "privatelink.oms.opinsights.azure.com"
    ods               = "privatelink.ods.opinsights.azure.com"
    automation        = "privatelink.azure-automation.net"
    automation_agent  = "privatelink.agentsvc.azure-automation.net"
    blob_storage      = "privatelink.blob.storage.azure.net"
    disk              = "privatelink.disk.azure.net"
  }
}

#--------------------------------------------------------------
# Flow Log Variables
#--------------------------------------------------------------

variable "vnet_flow_log_name" {
  description = "Name for the VNet flow log"
  type        = string
  default     = "fl-vnet-mgmt-prd-wus3-01"
}

variable "flow_log_enabled" {
  description = "Enable VNet flow logging"
  type        = bool
  default     = true
}

variable "flow_log_version" {
  description = "Version of the flow log format"
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
  description = "Enable Traffic Analytics"
  type        = bool
  default     = true
}

variable "traffic_analytics_interval" {
  description = "Interval in minutes for Traffic Analytics processing"
  type        = number
  default     = 10

  validation {
    condition     = contains([10, 60], var.traffic_analytics_interval)
    error_message = "Traffic analytics interval must be either 10 or 60 minutes."
  }
}

#--------------------------------------------------------------
# Network Watcher Variables
#--------------------------------------------------------------

variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-mgmt-prd-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "Resource group name for the Network Watcher"
  type        = string
  default     = "rg-nw-prd-mgmt-wus3-01"
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

variable "tfstate_subscription_id" {
  description = "Subscription ID for Terraform state storage"
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
