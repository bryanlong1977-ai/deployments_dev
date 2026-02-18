variable "subscription_id" {
  description = "The subscription ID for the DMZ subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "connectivity_subscription_id" {
  description = "The subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "eastus2"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    subscription  = "dmz"
  }
}

variable "network_resource_group_name" {
  description = "Name of the resource group for DMZ network resources"
  type        = string
  default     = "rg-network-prd-dmz-eus2-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the dedicated resource group for Network Watcher"
  type        = string
  default     = "rg-nw-prd-dmz-eus2-01"
}

variable "vnet_name" {
  description = "Name of the DMZ virtual network"
  type        = string
  default     = "vnet-dmz-prd-eus2-01"
}

variable "vnet_address_space" {
  description = "Address space for the DMZ virtual network"
  type        = list(string)
  default     = ["10.0.6.0/23"]
}

variable "dns_servers" {
  description = "List of DNS servers for the virtual network"
  type        = list(string)
  default     = []
}

variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-dmz-eus2-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.6.0/26"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-dmz-eus2-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.6.64/26"
}

variable "subnet_ns_mgmt_name" {
  description = "Name of the NetScaler management subnet"
  type        = string
  default     = "snet-ns-mgmt-dmz-eus2-01"
}

variable "subnet_ns_mgmt_address_prefix" {
  description = "Address prefix for the NetScaler management subnet"
  type        = string
  default     = "10.0.6.128/28"
}

variable "subnet_ns_client_name" {
  description = "Name of the NetScaler client subnet"
  type        = string
  default     = "snet-ns-client-dmz-eus2-01"
}

variable "subnet_ns_client_address_prefix" {
  description = "Address prefix for the NetScaler client subnet"
  type        = string
  default     = "10.0.6.160/27"
}

variable "subnet_ns_server_name" {
  description = "Name of the NetScaler server subnet"
  type        = string
  default     = "snet-ns-server-dmz-eus2-01"
}

variable "subnet_ns_server_address_prefix" {
  description = "Address prefix for the NetScaler server subnet"
  type        = string
  default     = "10.0.6.192/27"
}

variable "subnet_ifw_mgmt_name" {
  description = "Name of the ingress firewall management subnet"
  type        = string
  default     = "snet-ifw-mgmt-dmz-eus2-01"
}

variable "subnet_ifw_mgmt_address_prefix" {
  description = "Address prefix for the ingress firewall management subnet"
  type        = string
  default     = "10.0.6.224/28"
}

variable "subnet_ifw_untrust_name" {
  description = "Name of the ingress firewall untrust subnet"
  type        = string
  default     = "snet-ifw-untrust-dmz-eus2-01"
}

variable "subnet_ifw_untrust_address_prefix" {
  description = "Address prefix for the ingress firewall untrust subnet"
  type        = string
  default     = "10.0.7.0/27"
}

variable "subnet_ifw_trust_name" {
  description = "Name of the ingress firewall trust subnet"
  type        = string
  default     = "snet-ifw-trust-dmz-eus2-01"
}

variable "subnet_ifw_trust_address_prefix" {
  description = "Address prefix for the ingress firewall trust subnet"
  type        = string
  default     = "10.0.7.32/27"
}

variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-dmz-prd-eus2-01"
}

variable "private_endpoint_network_policies" {
  description = "Network policies for private endpoints"
  type        = string
  default     = "Disabled"
}

variable "peering_dmz_to_hub_name" {
  description = "Name of the VNet peering from DMZ to Hub"
  type        = string
  default     = "peer-dmz-to-hub"
}

variable "peering_hub_to_dmz_name" {
  description = "Name of the VNet peering from Hub to DMZ"
  type        = string
  default     = "peer-hub-to-dmz"
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

variable "peering_allow_gateway_transit_hub" {
  description = "Allow gateway transit on hub side of peering"
  type        = bool
  default     = true
}

variable "peering_allow_gateway_transit_dmz" {
  description = "Allow gateway transit on DMZ side of peering"
  type        = bool
  default     = false
}

variable "peering_use_remote_gateways_hub" {
  description = "Use remote gateways on hub side of peering"
  type        = bool
  default     = false
}

variable "peering_use_remote_gateways_dmz" {
  description = "Use remote gateways on DMZ side of peering"
  type        = bool
  default     = true
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
