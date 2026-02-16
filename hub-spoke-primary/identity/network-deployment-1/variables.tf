#------------------------------------------------------------------------------
# Subscription Variables
#------------------------------------------------------------------------------

variable "subscription_id" {
  description = "The subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "connectivity_subscription_id" {
  description = "The subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

#------------------------------------------------------------------------------
# Location Variables
#------------------------------------------------------------------------------

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

#------------------------------------------------------------------------------
# Resource Group Variables
#------------------------------------------------------------------------------

variable "network_resource_group_name" {
  description = "Name of the network resource group"
  type        = string
  default     = "rg-network-prd-idm-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the network watcher resource group (dedicated)"
  type        = string
  default     = "rg-nw-prd-idm-wus3-01"
}

variable "dns_resource_group_name" {
  description = "Name of the DNS resource group for Private DNS Resolver and Zones"
  type        = string
  default     = "rg-dns-prd-identity-wus3-01"
}

#------------------------------------------------------------------------------
# Virtual Network Variables
#------------------------------------------------------------------------------

variable "vnet_name" {
  description = "Name of the Identity virtual network"
  type        = string
  default     = "vnet-idm-prd-wus3-01"
}

variable "vnet_address_space" {
  description = "Address space for the Identity virtual network"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

#------------------------------------------------------------------------------
# Subnet Variables
#------------------------------------------------------------------------------

variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-idm-wus3-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.1.0/26"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-idm-wus3-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.1.64/26"
}

variable "subnet_inbound_name" {
  description = "Name of the DNS resolver inbound subnet"
  type        = string
  default     = "snet-inbound-idm-wus3-01"
}

variable "subnet_inbound_address_prefix" {
  description = "Address prefix for the DNS resolver inbound subnet"
  type        = string
  default     = "10.0.1.128/28"
}

variable "subnet_outbound_name" {
  description = "Name of the DNS resolver outbound subnet"
  type        = string
  default     = "snet-outbound-idm-wus3-01"
}

variable "subnet_outbound_address_prefix" {
  description = "Address prefix for the DNS resolver outbound subnet"
  type        = string
  default     = "10.0.1.144/28"
}

variable "subnet_dc_name" {
  description = "Name of the domain controllers subnet"
  type        = string
  default     = "snet-dc-idm-wus3-01"
}

variable "subnet_dc_address_prefix" {
  description = "Address prefix for the domain controllers subnet"
  type        = string
  default     = "10.0.1.160/27"
}

variable "subnet_ib_mgmt_name" {
  description = "Name of the Infoblox management subnet"
  type        = string
  default     = "snet-ib-mgmt-idm-wus3-01"
}

variable "subnet_ib_mgmt_address_prefix" {
  description = "Address prefix for the Infoblox management subnet"
  type        = string
  default     = "10.0.1.192/28"
}

variable "subnet_ib_lan1_name" {
  description = "Name of the Infoblox LAN1 subnet"
  type        = string
  default     = "snet-ib-lan1-idm-wus3-01"
}

variable "subnet_ib_lan1_address_prefix" {
  description = "Address prefix for the Infoblox LAN1 subnet"
  type        = string
  default     = "10.0.1.208/28"
}

#------------------------------------------------------------------------------
# Network Watcher Variables
#------------------------------------------------------------------------------

variable "network_watcher_name" {
  description = "Name of the network watcher"
  type        = string
  default     = "nw-idm-prd-wus3-01"
}

#------------------------------------------------------------------------------
# Private DNS Resolver Variables
#------------------------------------------------------------------------------

variable "private_dns_resolver_name" {
  description = "Name of the Private DNS Resolver"
  type        = string
  default     = "pdr-identity-prd-wus3-01"
}

variable "dns_resolver_inbound_endpoint_name" {
  description = "Name of the DNS resolver inbound endpoint"
  type        = string
  default     = "drie-identity-prd-wus3-01"
}

variable "dns_resolver_outbound_endpoint_name" {
  description = "Name of the DNS resolver outbound endpoint"
  type        = string
  default     = "droe-identity-prd-wus3-01"
}

#------------------------------------------------------------------------------
# Private DNS Zones Variables
#------------------------------------------------------------------------------

variable "private_dns_zones" {
  description = "List of private DNS zones to create"
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

#------------------------------------------------------------------------------
# DNS Forwarding Variables
#------------------------------------------------------------------------------

variable "dns_forwarding_enabled" {
  description = "Whether DNS forwarding is enabled"
  type        = bool
  default     = true
}

variable "dns_forwarding_ruleset_name" {
  description = "Name of the DNS forwarding ruleset"
  type        = string
  default     = "dnsfrs-identity-prd-wus3-01"
}

variable "dns_forwarding_rules" {
  description = "List of DNS forwarding rules"
  type = list(object({
    domain           = string
    targetDnsServers = list(string)
    state            = string
  }))
  default = [
    {
      domain           = "ambg.local"
      targetDnsServers = ["8.8.8.8"]
      state            = "Enabled"
    }
  ]
}

#------------------------------------------------------------------------------
# VNet Peering Variables
#------------------------------------------------------------------------------

variable "use_remote_gateways" {
  description = "Whether to use remote gateways for VNet peering (set to false if no gateway exists in hub yet)"
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# Tags Variables
#------------------------------------------------------------------------------

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "8b492308-bab3-41e1-a8cb-1348dfea4227"
    managed_by    = "Terraform"
  }
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
