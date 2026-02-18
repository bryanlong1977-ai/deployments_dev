variable "subscription_id" {
  description = "The Azure subscription ID for the connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "resource_group_name" {
  description = "The name of the resource group for hub network resources"
  type        = string
  default     = "rg-network-prd-hub-eus2-01"
}

variable "network_watcher_resource_group_name" {
  description = "The name of the dedicated resource group for Network Watcher"
  type        = string
  default     = "rg-nw-prd-hub-eus2-01"
}

variable "vnet_name" {
  description = "The name of the hub virtual network"
  type        = string
  default     = "vnet-hub-prd-eus2-01"
}

variable "vnet_address_space" {
  description = "The address space for the hub virtual network"
  type        = list(string)
  default     = ["10.0.0.0/22"]
}

variable "dns_servers" {
  description = "The DNS servers for the virtual network (empty list uses Azure default DNS)"
  type        = list(string)
  default     = []
}

variable "subnet_pe_name" {
  description = "The name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-hub-eus2-01"
}

variable "subnet_pe_address_prefix" {
  description = "The address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.0.0/26"
}

variable "private_endpoint_network_policies" {
  description = "Network policies for private endpoints (Enabled or Disabled)"
  type        = string
  default     = "Disabled"
}

variable "subnet_tools_name" {
  description = "The name of the tools subnet"
  type        = string
  default     = "snet-tools-hub-eus2-01"
}

variable "subnet_tools_address_prefix" {
  description = "The address prefix for the tools subnet"
  type        = string
  default     = "10.0.0.64/26"
}

variable "subnet_fw_mgmt_name" {
  description = "The name of the firewall management subnet"
  type        = string
  default     = "snet-fw-mgmt-hub-eus2-01"
}

variable "subnet_fw_mgmt_address_prefix" {
  description = "The address prefix for the firewall management subnet"
  type        = string
  default     = "10.0.0.128/28"
}

variable "subnet_fw_untrust_name" {
  description = "The name of the firewall untrust subnet"
  type        = string
  default     = "snet-fw-untrust-hub-eus2-01"
}

variable "subnet_fw_untrust_address_prefix" {
  description = "The address prefix for the firewall untrust subnet"
  type        = string
  default     = "10.0.0.160/27"
}

variable "subnet_fw_trust_name" {
  description = "The name of the firewall trust subnet"
  type        = string
  default     = "snet-fw-trust-hub-eus2-01"
}

variable "subnet_fw_trust_address_prefix" {
  description = "The address prefix for the firewall trust subnet"
  type        = string
  default     = "10.0.0.192/27"
}

variable "subnet_gateway_name" {
  description = "The name of the gateway subnet (must be GatewaySubnet for Azure gateways)"
  type        = string
  default     = "GatewaySubnet"
}

variable "subnet_gateway_address_prefix" {
  description = "The address prefix for the gateway subnet"
  type        = string
  default     = "10.0.0.224/27"
}

variable "subnet_route_server_name" {
  description = "The name of the route server subnet (must be RouteServerSubnet for Azure Route Server)"
  type        = string
  default     = "RouteServerSubnet"
}

variable "subnet_route_server_address_prefix" {
  description = "The address prefix for the route server subnet"
  type        = string
  default     = "10.0.1.0/27"
}

variable "network_watcher_name" {
  description = "The name of the network watcher"
  type        = string
  default     = "nw-hub-prd-eus2-01"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    subscription  = "connectivity"
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
