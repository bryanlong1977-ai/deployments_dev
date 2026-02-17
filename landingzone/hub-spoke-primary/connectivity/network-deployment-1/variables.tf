variable "subscription_id" {
  description = "The Azure subscription ID for the Connectivity subscription"
  type        = string
  default     = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "network_resource_group_name" {
  description = "Name of the resource group for hub network resources"
  type        = string
  default     = "rg-network-prd-hub-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the dedicated resource group for Network Watcher"
  type        = string
  default     = "rg-nw-prd-hub-wus3-01"
}

variable "vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
  default     = "vnet-hub-prd-wus3-01"
}

variable "vnet_address_space" {
  description = "Address space for the hub virtual network"
  type        = list(string)
  default     = ["10.0.0.0/22"]
}

variable "dns_servers" {
  description = "List of DNS server IP addresses for the virtual network"
  type        = list(string)
  default     = []
}

variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-hub-wus3-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoints subnet"
  type        = string
  default     = "10.0.0.0/26"
}

variable "private_endpoint_network_policies" {
  description = "Network policies for private endpoints (Enabled or Disabled)"
  type        = string
  default     = "Disabled"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-hub-wus3-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.0.64/26"
}

variable "subnet_fw_mgmt_name" {
  description = "Name of the firewall management subnet"
  type        = string
  default     = "snet-fw-mgmt-hub-wus3-01"
}

variable "subnet_fw_mgmt_address_prefix" {
  description = "Address prefix for the firewall management subnet"
  type        = string
  default     = "10.0.0.128/28"
}

variable "subnet_fw_untrust_name" {
  description = "Name of the firewall untrust subnet"
  type        = string
  default     = "snet-fw-untrust-hub-wus3-01"
}

variable "subnet_fw_untrust_address_prefix" {
  description = "Address prefix for the firewall untrust subnet"
  type        = string
  default     = "10.0.0.160/27"
}

variable "subnet_fw_trust_name" {
  description = "Name of the firewall trust subnet"
  type        = string
  default     = "snet-fw-trust-hub-wus3-01"
}

variable "subnet_fw_trust_address_prefix" {
  description = "Address prefix for the firewall trust subnet"
  type        = string
  default     = "10.0.0.192/27"
}

variable "subnet_gateway_name" {
  description = "Name of the gateway subnet (must be GatewaySubnet)"
  type        = string
  default     = "GatewaySubnet"
}

variable "subnet_gateway_address_prefix" {
  description = "Address prefix for the gateway subnet"
  type        = string
  default     = "10.0.0.224/27"
}

variable "subnet_route_server_name" {
  description = "Name of the route server subnet (must be RouteServerSubnet)"
  type        = string
  default     = "RouteServerSubnet"
}

variable "subnet_route_server_address_prefix" {
  description = "Address prefix for the route server subnet"
  type        = string
  default     = "10.0.1.0/27"
}

variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-hub-prd-wus3-01"
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
