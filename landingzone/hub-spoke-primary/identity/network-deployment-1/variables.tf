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

variable "region" {
  description = "The Azure region for all resources"
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "The environment (Production, Development, etc.)"
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
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    managed_by    = "Terraform"
  }
}

#------------------------------------------------------------------------------
# Resource Group Names
#------------------------------------------------------------------------------

variable "network_resource_group_name" {
  description = "Name of the network resource group"
  type        = string
  default     = "rg-network-prd-idm-eus2-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the Network Watcher resource group"
  type        = string
  default     = "rg-nw-prd-idm-eus2-01"
}

variable "dns_resource_group_name" {
  description = "Name of the DNS resource group"
  type        = string
  default     = "rg-dns-prd-identity-eus2-01"
}

#------------------------------------------------------------------------------
# Virtual Network Configuration
#------------------------------------------------------------------------------

variable "vnet_name" {
  description = "Name of the Identity virtual network"
  type        = string
  default     = "vnet-idm-prd-eus2-01"
}

variable "vnet_address_space" {
  description = "Address space for the Identity virtual network"
  type        = list(string)
  default     = ["10.0.4.0/24"]
}

#------------------------------------------------------------------------------
# Subnet Configuration
#------------------------------------------------------------------------------

variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-idm-eus2-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.4.0/26"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-idm-eus2-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.4.64/26"
}

variable "subnet_inbound_name" {
  description = "Name of the DNS resolver inbound subnet"
  type        = string
  default     = "snet-inbound-idm-eus2-01"
}

variable "subnet_inbound_address_prefix" {
  description = "Address prefix for the DNS resolver inbound subnet"
  type        = string
  default     = "10.0.4.128/28"
}

variable "subnet_outbound_name" {
  description = "Name of the DNS resolver outbound subnet"
  type        = string
  default     = "snet-outbound-idm-eus2-01"
}

variable "subnet_outbound_address_prefix" {
  description = "Address prefix for the DNS resolver outbound subnet"
  type        = string
  default     = "10.0.4.144/28"
}

variable "subnet_dc_name" {
  description = "Name of the domain controllers subnet"
  type        = string
  default     = "snet-dc-idm-eus2-01"
}

variable "subnet_dc_address_prefix" {
  description = "Address prefix for the domain controllers subnet"
  type        = string
  default     = "10.0.4.160/27"
}

variable "subnet_ib_mgmt_name" {
  description = "Name of the Infoblox management subnet"
  type        = string
  default     = "snet-ib-mgmt-idm-eus2-01"
}

variable "subnet_ib_mgmt_address_prefix" {
  description = "Address prefix for the Infoblox management subnet"
  type        = string
  default     = "10.0.4.192/28"
}

variable "subnet_ib_lan1_name" {
  description = "Name of the Infoblox LAN1 subnet"
  type        = string
  default     = "snet-ib-lan1-idm-eus2-01"
}

variable "subnet_ib_lan1_address_prefix" {
  description = "Address prefix for the Infoblox LAN1 subnet"
  type        = string
  default     = "10.0.4.208/28"
}

#------------------------------------------------------------------------------
# Network Watcher Configuration
#------------------------------------------------------------------------------

variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-idm-prd-eus2-01"
}

#------------------------------------------------------------------------------
# VNet Peering Configuration
#------------------------------------------------------------------------------

variable "peering_identity_to_hub_name" {
  description = "Name of the peering from Identity to Hub"
  type        = string
  default     = "peer-identity-to-hub"
}

variable "peering_hub_to_identity_name" {
  description = "Name of the peering from Hub to Identity"
  type        = string
  default     = "peer-hub-to-identity"
}

variable "use_remote_gateways" {
  description = "Whether to use remote gateways from the Hub VNet (set to false if Hub has no gateway yet)"
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# DNS Resolver Configuration
#------------------------------------------------------------------------------

variable "dns_resolver_name" {
  description = "Name of the Private DNS Resolver"
  type        = string
  default     = "pdr-identity-prd-eus2-01"
}

variable "dns_inbound_endpoint_name" {
  description = "Name of the DNS Resolver Inbound Endpoint"
  type        = string
  default     = "drie-identity-prd-eus2-01"
}

variable "dns_outbound_endpoint_name" {
  description = "Name of the DNS Resolver Outbound Endpoint"
  type        = string
  default     = "droe-identity-prd-eus2-01"
}

#------------------------------------------------------------------------------
# DNS Forwarding Configuration
#------------------------------------------------------------------------------

variable "dns_forwarding_enabled" {
  description = "Whether to enable DNS forwarding"
  type        = bool
  default     = true
}

variable "dns_forwarding_ruleset_name" {
  description = "Name of the DNS Forwarding Ruleset"
  type        = string
  default     = "dnsfrs-identity-prd-eus2-01"
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
# Private DNS Zones Configuration
#------------------------------------------------------------------------------

variable "private_dns_zones" {
  description = "List of Private DNS zones to create"
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
# Remote State Configuration
#------------------------------------------------------------------------------

variable "remote_state_resource_group" {
  description = "Resource group name for the Terraform state storage account"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "remote_state_storage_account" {
  description = "Storage account name for the Terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "remote_state_container" {
  description = "Container name for the Terraform state"
  type        = string
  default     = "tfstate"
}

variable "connectivity_network_state_key" {
  description = "State file key for the Connectivity Network Deployment 1"
  type        = string
  default     = "hub-spoke-primary/connectivity/network-deployment-1.tfstate"
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
