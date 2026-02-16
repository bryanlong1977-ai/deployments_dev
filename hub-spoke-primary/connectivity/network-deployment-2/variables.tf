#----------------------------------------------------------
# Subscription Variables
#----------------------------------------------------------
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

#----------------------------------------------------------
# Common Variables
#----------------------------------------------------------
variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "environment" {
  description = "The environment name (Production, Development, etc.)"
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

variable "availability_zones" {
  description = "List of availability zones for zone-redundant resources"
  type        = list(string)
  default     = ["1", "2", "3"]
}

#----------------------------------------------------------
# NAT Gateway Variables
#----------------------------------------------------------
variable "nat_gateway_resource_group_name" {
  description = "The name of the resource group for NAT Gateway"
  type        = string
  default     = "rg-natgw-hub-prd-wus3-01"
}

variable "nat_gateway_name" {
  description = "The name of the NAT Gateway"
  type        = string
  default     = "natgw-hub-prd-wus3-01"
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

variable "public_ip_prefix_name" {
  description = "The name of the Public IP Prefix for NAT Gateway"
  type        = string
  default     = "pipp-hub-prd-wus3-01"
}

variable "public_ip_prefix_length" {
  description = "The prefix length for the Public IP Prefix (29 = 8 IPs)"
  type        = number
  default     = 29
}

variable "public_ip_prefix_sku" {
  description = "The SKU of the Public IP Prefix"
  type        = string
  default     = "Standard"
}

variable "fw_untrust_subnet_name" {
  description = "The name of the firewall untrust subnet for NAT Gateway association"
  type        = string
  default     = "snet-fw-untrust-hub-wus3-01"
}

#----------------------------------------------------------
# ExpressRoute Gateway Variables
#----------------------------------------------------------
variable "expressroute_gateway_resource_group_name" {
  description = "The name of the resource group for ExpressRoute Gateway"
  type        = string
  default     = "rg-ergw-hub-prd-wus3-01"
}

variable "expressroute_gateway_name" {
  description = "The name of the ExpressRoute Gateway"
  type        = string
  default     = "ergw-hub-prd-wus3-01"
}

variable "expressroute_gateway_sku" {
  description = "The SKU of the ExpressRoute Gateway"
  type        = string
  default     = "Standard"
}

variable "expressroute_gateway_active_active" {
  description = "Whether to enable active-active mode for the ExpressRoute Gateway"
  type        = bool
  default     = false
}

variable "expressroute_gateway_enable_bgp" {
  description = "Whether to enable BGP for the ExpressRoute Gateway"
  type        = bool
  default     = true
}

variable "expressroute_gateway_ip_config_name" {
  description = "The name of the IP configuration for ExpressRoute Gateway"
  type        = string
  default     = "ipconfig-ergw"
}

variable "expressroute_gateway_private_ip_allocation" {
  description = "The private IP address allocation method"
  type        = string
  default     = "Dynamic"
}

variable "expressroute_gateway_pip_name" {
  description = "The name of the Public IP for ExpressRoute Gateway"
  type        = string
  default     = "pip-ergw-hub-prd-wus3-01"
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

variable "gateway_subnet_name" {
  description = "The name of the Gateway Subnet"
  type        = string
  default     = "GatewaySubnet"
}

#----------------------------------------------------------
# External Load Balancer Variables
#----------------------------------------------------------
variable "external_lb_resource_group_name" {
  description = "The name of the resource group for External Load Balancer"
  type        = string
  default     = "rg-elb-hub-prd-wus3-01"
}

variable "external_lb_name" {
  description = "The name of the External Load Balancer"
  type        = string
  default     = "lbe-hub-prd-wus3-01"
}

variable "external_lb_sku" {
  description = "The SKU of the External Load Balancer"
  type        = string
  default     = "Standard"
}

variable "external_lb_sku_tier" {
  description = "The SKU tier of the External Load Balancer"
  type        = string
  default     = "Regional"
}

variable "external_lb_frontend_ip_config_name" {
  description = "The name of the frontend IP configuration for External Load Balancer"
  type        = string
  default     = "feip-external"
}

variable "external_lb_backend_pool_name" {
  description = "The name of the backend address pool for External Load Balancer"
  type        = string
  default     = "bepool-external"
}

variable "external_lb_probe_name" {
  description = "The name of the health probe for External Load Balancer"
  type        = string
  default     = "probe-external"
}

variable "external_lb_probe_protocol" {
  description = "The protocol for the External Load Balancer health probe"
  type        = string
  default     = "Tcp"
}

variable "external_lb_probe_port" {
  description = "The port for the External Load Balancer health probe"
  type        = number
  default     = 443
}

variable "external_lb_probe_interval" {
  description = "The interval in seconds for the health probe"
  type        = number
  default     = 5
}

variable "external_lb_probe_number" {
  description = "The number of probes before marking unhealthy"
  type        = number
  default     = 2
}

variable "external_lb_pip_prefix_name" {
  description = "The name of the Public IP Prefix for External Load Balancer"
  type        = string
  default     = "pipp-elb-hub-prd-wus3-01"
}

variable "external_lb_pip_prefix_length" {
  description = "The prefix length for the External LB Public IP Prefix"
  type        = number
  default     = 31
}

variable "external_lb_pip_prefix_sku" {
  description = "The SKU of the External LB Public IP Prefix"
  type        = string
  default     = "Standard"
}

variable "external_lb_pip_name" {
  description = "The name of the Public IP for External Load Balancer"
  type        = string
  default     = "pip-elb-hub-prd-wus3-01"
}

variable "external_lb_pip_allocation_method" {
  description = "The allocation method for the External LB Public IP"
  type        = string
  default     = "Static"
}

variable "external_lb_pip_sku" {
  description = "The SKU of the External LB Public IP"
  type        = string
  default     = "Standard"
}

#----------------------------------------------------------
# Diagnostic Settings Variables
#----------------------------------------------------------
variable "natgw_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for NAT Gateway"
  type        = string
  default     = "diag-natgw-hub-prd-wus3-01"
}

variable "ergw_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for ExpressRoute Gateway"
  type        = string
  default     = "diag-ergw-hub-prd-wus3-01"
}

variable "elb_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for External Load Balancer"
  type        = string
  default     = "diag-elb-hub-prd-wus3-01"
}

variable "natgw_pip_prefix_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for NAT Gateway Public IP Prefix"
  type        = string
  default     = "diag-pipp-natgw-hub-prd-wus3-01"
}

variable "ergw_pip_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for ExpressRoute Gateway Public IP"
  type        = string
  default     = "diag-pip-ergw-hub-prd-wus3-01"
}

variable "elb_pip_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for External LB Public IP"
  type        = string
  default     = "diag-pip-elb-hub-prd-wus3-01"
}

variable "vnet_diagnostic_setting_name" {
  description = "The name of the diagnostic setting for Virtual Network"
  type        = string
  default     = "diag-vnet-hub-prd-wus3-01"
}

#----------------------------------------------------------
# VNet Flow Log Variables
#----------------------------------------------------------
variable "vnet_flow_log_name" {
  description = "The name of the VNet Flow Log"
  type        = string
  default     = "fl-vnet-hub-prd-wus3-01"
}

variable "vnet_flow_log_enabled" {
  description = "Whether the VNet Flow Log is enabled"
  type        = bool
  default     = true
}

variable "vnet_flow_log_version" {
  description = "The version of the VNet Flow Log"
  type        = number
  default     = 2
}

variable "vnet_flow_log_retention_enabled" {
  description = "Whether retention is enabled for VNet Flow Logs"
  type        = bool
  default     = true
}

variable "vnet_flow_log_retention_days" {
  description = "The number of days to retain VNet Flow Logs"
  type        = number
  default     = 90
}

variable "vnet_flow_log_traffic_analytics_enabled" {
  description = "Whether Traffic Analytics is enabled for VNet Flow Logs"
  type        = bool
  default     = true
}

variable "vnet_flow_log_traffic_analytics_interval" {
  description = "The interval in minutes for Traffic Analytics"
  type        = number
  default     = 10
}

#----------------------------------------------------------
# DNS Integration Variables
#----------------------------------------------------------
variable "hub_dns_vnet_link_name" {
  description = "The name of the DNS forwarding ruleset VNet link for hub"
  type        = string
  default     = "link-hub-vnet-dns"
}

variable "private_dns_zones" {
  description = "List of Private DNS zones to link to the hub VNet"
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
