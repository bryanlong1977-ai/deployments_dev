# =============================================================================
# Variables for DMZ Network Deployment 1
# =============================================================================

# -----------------------------------------------------------------------------
# Subscription Configuration
# -----------------------------------------------------------------------------
variable "subscription_id" {
  description = "The Azure subscription ID for the DMZ subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "connectivity_subscription_id" {
  description = "The Azure subscription ID for the Connectivity subscription (for hub-side peering)"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

# -----------------------------------------------------------------------------
# Project Configuration
# -----------------------------------------------------------------------------
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
  description = "The environment (Production, Development, etc.)"
  type        = string
  default     = "Production"
}

variable "deployment_id" {
  description = "Unique identifier for this deployment"
  type        = string
  default     = "8b492308-bab3-41e1-a8cb-1348dfea4227"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# Resource Group Names
# -----------------------------------------------------------------------------
variable "network_resource_group_name" {
  description = "Name of the resource group for DMZ network resources"
  type        = string
  default     = "rg-network-prd-dmz-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the dedicated resource group for Network Watcher"
  type        = string
  default     = "rg-nw-prd-dmz-wus3-01"
}

# -----------------------------------------------------------------------------
# Virtual Network Configuration
# -----------------------------------------------------------------------------
variable "vnet_name" {
  description = "Name of the DMZ virtual network"
  type        = string
  default     = "vnet-dmz-prd-wus3-01"
}

variable "vnet_address_space" {
  description = "Address space for the DMZ virtual network"
  type        = list(string)
  default     = ["10.0.2.0/23"]
}

variable "dns_servers" {
  description = "Custom DNS servers for the virtual network (empty list uses Azure default)"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Subnet Configuration
# -----------------------------------------------------------------------------
variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-dmz-wus3-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.2.0/26"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-dmz-wus3-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.2.64/26"
}

variable "subnet_ns_mgmt_name" {
  description = "Name of the NetScaler management subnet"
  type        = string
  default     = "snet-ns-mgmt-dmz-wus3-01"
}

variable "subnet_ns_mgmt_address_prefix" {
  description = "Address prefix for the NetScaler management subnet"
  type        = string
  default     = "10.0.2.128/28"
}

variable "subnet_ns_client_name" {
  description = "Name of the NetScaler client subnet"
  type        = string
  default     = "snet-ns-client-dmz-wus3-01"
}

variable "subnet_ns_client_address_prefix" {
  description = "Address prefix for the NetScaler client subnet"
  type        = string
  default     = "10.0.2.160/27"
}

variable "subnet_ns_server_name" {
  description = "Name of the NetScaler server subnet"
  type        = string
  default     = "snet-ns-server-dmz-wus3-01"
}

variable "subnet_ns_server_address_prefix" {
  description = "Address prefix for the NetScaler server subnet"
  type        = string
  default     = "10.0.2.192/27"
}

variable "subnet_ifw_mgmt_name" {
  description = "Name of the ingress firewall management subnet"
  type        = string
  default     = "snet-ifw-mgmt-dmz-wus3-01"
}

variable "subnet_ifw_mgmt_address_prefix" {
  description = "Address prefix for the ingress firewall management subnet"
  type        = string
  default     = "10.0.2.224/28"
}

variable "subnet_ifw_untrust_name" {
  description = "Name of the ingress firewall untrust subnet"
  type        = string
  default     = "snet-ifw-untrust-dmz-wus3-01"
}

variable "subnet_ifw_untrust_address_prefix" {
  description = "Address prefix for the ingress firewall untrust subnet"
  type        = string
  default     = "10.0.3.0/27"
}

variable "subnet_ifw_trust_name" {
  description = "Name of the ingress firewall trust subnet"
  type        = string
  default     = "snet-ifw-trust-dmz-wus3-01"
}

variable "subnet_ifw_trust_address_prefix" {
  description = "Address prefix for the ingress firewall trust subnet"
  type        = string
  default     = "10.0.3.32/27"
}

variable "private_endpoint_network_policies" {
  description = "Network policies for private endpoint subnet (Enabled or Disabled)"
  type        = string
  default     = "Disabled"
}

# -----------------------------------------------------------------------------
# Network Watcher Configuration
# -----------------------------------------------------------------------------
variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-dmz-prd-wus3-01"
}

# -----------------------------------------------------------------------------
# VNet Peering Configuration
# -----------------------------------------------------------------------------
variable "peering_dmz_to_hub_name" {
  description = "Name for the DMZ to Hub VNet peering"
  type        = string
  default     = "peer-dmz-to-hub"
}

variable "peering_hub_to_dmz_name" {
  description = "Name for the Hub to DMZ VNet peering"
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
  description = "Allow gateway transit on hub side (hub allows transit to spokes)"
  type        = bool
  default     = true
}

variable "peering_allow_gateway_transit_spoke" {
  description = "Allow gateway transit on spoke side (spokes do not allow transit)"
  type        = bool
  default     = false
}

variable "peering_use_remote_gateways" {
  description = "Use remote gateways (spoke uses hub's gateway)"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Remote State Configuration
# -----------------------------------------------------------------------------
variable "remote_state_resource_group_name" {
  description = "Resource group name for terraform state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "remote_state_storage_account_name" {
  description = "Storage account name for terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "remote_state_container_name" {
  description = "Container name for terraform state"
  type        = string
  default     = "tfstate"
}

variable "remote_state_subscription_id" {
  description = "Subscription ID where terraform state storage is located"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "connectivity_network_state_key" {
  description = "State file key for connectivity network deployment 1"
  type        = string
  default     = "hub-spoke-primary/connectivity/network-deployment-1.tfstate"
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
