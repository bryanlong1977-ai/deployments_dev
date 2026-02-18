variable "subscription_id" {
  description = "The subscription ID for the Management subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "connectivity_subscription_id" {
  description = "The subscription ID for the Connectivity subscription (for cross-subscription peering)"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    subscription  = "management"
  }
}

variable "network_resource_group_name" {
  description = "Name of the resource group for network resources"
  type        = string
  default     = "rg-network-prd-mgmt-eus2-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the dedicated resource group for Network Watcher"
  type        = string
  default     = "rg-nw-prd-mgmt-eus2-01"
}

variable "vnet_name" {
  description = "Name of the Management virtual network"
  type        = string
  default     = "vnet-mgmt-prd-eus2-01"
}

variable "vnet_address_space" {
  description = "Address space for the Management virtual network"
  type        = list(string)
  default     = ["10.0.5.0/24"]
}

variable "dns_servers" {
  description = "Custom DNS servers for the virtual network (empty list uses Azure default)"
  type        = list(string)
  default     = []
}

variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-mgmt-eus2-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.5.0/26"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-mgmt-eus2-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.5.64/26"
}

variable "private_endpoint_network_policies" {
  description = "Network policies for private endpoints subnet"
  type        = string
  default     = "Disabled"
}

variable "private_link_service_network_policies_enabled" {
  description = "Enable network policies for private link service"
  type        = bool
  default     = false
}

variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-mgmt-prd-eus2-01"
}

variable "peering_mgmt_to_hub_name" {
  description = "Name of the VNet peering from Management to Hub"
  type        = string
  default     = "peer-mgmt-to-hub"
}

variable "peering_hub_to_mgmt_name" {
  description = "Name of the VNet peering from Hub to Management"
  type        = string
  default     = "peer-hub-to-mgmt"
}

variable "peering_allow_virtual_network_access" {
  description = "Allow virtual network access for peering"
  type        = bool
  default     = true
}

variable "peering_allow_forwarded_traffic" {
  description = "Allow forwarded traffic for peering"
  type        = bool
  default     = true
}

variable "peering_spoke_allow_gateway_transit" {
  description = "Allow gateway transit on spoke side (should be false for spokes)"
  type        = bool
  default     = false
}

variable "peering_spoke_use_remote_gateways" {
  description = "Use remote gateways on spoke side (enables spoke to use hub gateway)"
  type        = bool
  default     = false
}

variable "peering_hub_allow_gateway_transit" {
  description = "Allow gateway transit on hub side (should be true for hub)"
  type        = bool
  default     = true
}

variable "peering_hub_use_remote_gateways" {
  description = "Use remote gateways on hub side (should be false for hub)"
  type        = bool
  default     = false
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
