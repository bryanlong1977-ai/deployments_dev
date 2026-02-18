#------------------------------------------------------------------------------
# Provider Variables
#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
# Common Variables
#------------------------------------------------------------------------------
variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
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
  description = "The deployment ID for tagging"
  type        = string
  default     = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
}

#------------------------------------------------------------------------------
# VNet Variables
#------------------------------------------------------------------------------
variable "vnet_name" {
  description = "The name of the Hub Virtual Network"
  type        = string
  default     = "vnet-hub-prd-eus2-01"
}

#------------------------------------------------------------------------------
# NAT Gateway Variables
#------------------------------------------------------------------------------
variable "nat_gateway_resource_group_name" {
  description = "The name of the resource group for NAT Gateway"
  type        = string
  default     = "rg-natgw-hub-prd-eus2-01"
}

variable "nat_gateway_name" {
  description = "The name of the NAT Gateway"
  type        = string
  default     = "natgw-hub-prd-eus2-01"
}

variable "nat_gateway_sku" {
  description = "The SKU of the NAT Gateway"
  type        = string
  default     = "Standard"
}

variable "nat_gateway_idle_timeout" {
  description = "The idle timeout in minutes for the NAT Gateway"
  type        = number
  default     = 10
}

variable "nat_gateway_zones" {
  description = "The availability zones for the NAT Gateway"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "nat_gateway_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for NAT Gateway"
  type        = string
  default     = "diag-natgw-hub-prd-eus2-01"
}

#------------------------------------------------------------------------------
# Public IP Prefix Variables
#------------------------------------------------------------------------------
variable "public_ip_prefix_name" {
  description = "The name of the Public IP Prefix for NAT Gateway"
  type        = string
  default     = "pipp-hub-prd-eus2-01"
}

variable "public_ip_prefix_length" {
  description = "The prefix length for the Public IP Prefix (/29 = 8 IPs)"
  type        = number
  default     = 29
}

variable "public_ip_prefix_sku" {
  description = "The SKU of the Public IP Prefix"
  type        = string
  default     = "Standard"
}

variable "public_ip_prefix_zones" {
  description = "The availability zones for the Public IP Prefix"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "public_ip_prefix_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for Public IP Prefix"
  type        = string
  default     = "diag-pipp-hub-prd-eus2-01"
}

#------------------------------------------------------------------------------
# ExpressRoute Gateway Variables
#------------------------------------------------------------------------------
variable "expressroute_gateway_resource_group_name" {
  description = "The name of the resource group for ExpressRoute Gateway"
  type        = string
  default     = "rg-ergw-hub-prd-eus2-01"
}

variable "expressroute_gateway_name" {
  description = "The name of the ExpressRoute Gateway"
  type        = string
  default     = "ergw-hub-prd-eus2-01"
}

variable "expressroute_gateway_sku" {
  description = "The SKU of the ExpressRoute Gateway"
  type        = string
  default     = "ErGw1AZ"

  validation {
    condition     = contains(["Standard", "HighPerformance", "UltraPerformance", "ErGw1AZ", "ErGw2AZ", "ErGw3AZ"], var.expressroute_gateway_sku)
    error_message = "The ExpressRoute Gateway SKU must be one of: Standard, HighPerformance, UltraPerformance, ErGw1AZ, ErGw2AZ, ErGw3AZ."
  }
}

variable "expressroute_gateway_active_active" {
  description = "Enable active-active mode for the ExpressRoute Gateway"
  type        = bool
  default     = false
}

variable "expressroute_gateway_enable_bgp" {
  description = "Enable BGP for the ExpressRoute Gateway"
  type        = bool
  default     = true
}

variable "expressroute_gateway_ip_config_name" {
  description = "The name of the IP configuration for ExpressRoute Gateway"
  type        = string
  default     = "ipconfig-ergw"
}

variable "expressroute_gateway_pip_name" {
  description = "The name of the Public IP for ExpressRoute Gateway"
  type        = string
  default     = "pip-ergw-hub-prd-eus2-01"
}

variable "expressroute_gateway_pip_allocation_method" {
  description = "The allocation method for the ExpressRoute Gateway Public IP"
  type        = string
  default     = "Static"
}

variable "expressroute_gateway_pip_sku" {
  description = "The SKU of the ExpressRoute Gateway Public IP"
  type        = string
  default     = "Standard"
}

variable "expressroute_gateway_pip_zones" {
  description = "The availability zones for the ExpressRoute Gateway Public IP"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "expressroute_gateway_pip_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for ExpressRoute Gateway Public IP"
  type        = string
  default     = "diag-pip-ergw-hub-prd-eus2-01"
}

variable "expressroute_gateway_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for ExpressRoute Gateway"
  type        = string
  default     = "diag-ergw-hub-prd-eus2-01"
}

#------------------------------------------------------------------------------
# Hub VNet Diagnostic Settings Variables
#------------------------------------------------------------------------------
variable "hub_vnet_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for Hub VNet"
  type        = string
  default     = "diag-vnet-hub-prd-eus2-01"
}

#------------------------------------------------------------------------------
# Flow Log Variables
#------------------------------------------------------------------------------
variable "hub_vnet_flow_log_name" {
  description = "The name of the VNet Flow Log for Hub VNet"
  type        = string
  default     = "fl-vnet-hub-prd-eus2-01"
}

variable "flow_log_enabled" {
  description = "Enable or disable the flow log"
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

#------------------------------------------------------------------------------
# Private DNS Zone Variables
#------------------------------------------------------------------------------
variable "private_dns_zones" {
  description = "List of Private DNS Zones to link to the Hub VNet"
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

#------------------------------------------------------------------------------
# Linked Subnets for NAT Gateway
#------------------------------------------------------------------------------
variable "nat_gateway_linked_subnets" {
  description = "List of subnet names to link to the NAT Gateway"
  type        = list(string)
  default     = ["snet-fw-untrust-hub-eus2-01"]
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
