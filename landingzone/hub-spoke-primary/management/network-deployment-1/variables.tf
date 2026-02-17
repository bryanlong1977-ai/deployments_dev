# =============================================================================
# Variables for Management Network Deployment 1
# =============================================================================

# -----------------------------------------------------------------------------
# Core Configuration
# -----------------------------------------------------------------------------
variable "subscription_id" {
  description = "The Azure subscription ID for the Management subscription"
  type        = string
  default     = "39f647ab-5261-47b0-ad91-1719dcd107a1"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "westus3"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    subscription  = "management"
    deployed_by   = "terraform"
  }
}

# -----------------------------------------------------------------------------
# Resource Group Configuration
# -----------------------------------------------------------------------------
variable "network_resource_group_name" {
  description = "Name of the resource group for network resources"
  type        = string
  default     = "rg-network-prd-mgmt-wus3-01"
}

variable "network_watcher_resource_group_name" {
  description = "Name of the dedicated resource group for Network Watcher"
  type        = string
  default     = "rg-nw-prd-mgmt-wus3-01"
}

# -----------------------------------------------------------------------------
# Virtual Network Configuration
# -----------------------------------------------------------------------------
variable "vnet_name" {
  description = "Name of the Management virtual network"
  type        = string
  default     = "vnet-mgmt-prd-wus3-01"
}

variable "vnet_address_space" {
  description = "Address space for the Management virtual network"
  type        = list(string)
  default     = ["10.0.5.0/24"]
}

variable "dns_servers" {
  description = "Custom DNS servers for the virtual network. Empty list uses Azure default DNS."
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Subnet Configuration
# -----------------------------------------------------------------------------
variable "subnet_pe_name" {
  description = "Name of the private endpoint subnet"
  type        = string
  default     = "snet-pe-mgmt-wus3-01"
}

variable "subnet_pe_address_prefix" {
  description = "Address prefix for the private endpoint subnet"
  type        = string
  default     = "10.0.5.0/26"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-mgmt-wus3-01"
}

variable "subnet_tools_address_prefix" {
  description = "Address prefix for the tools subnet"
  type        = string
  default     = "10.0.5.64/26"
}

variable "private_endpoint_network_policies" {
  description = "Network policies for private endpoints on subnets (Enabled, Disabled, NetworkSecurityGroupEnabled, RouteTableEnabled)"
  type        = string
  default     = "Disabled"
  validation {
    condition     = contains(["Enabled", "Disabled", "NetworkSecurityGroupEnabled", "RouteTableEnabled"], var.private_endpoint_network_policies)
    error_message = "private_endpoint_network_policies must be one of: Enabled, Disabled, NetworkSecurityGroupEnabled, RouteTableEnabled."
  }
}

# -----------------------------------------------------------------------------
# Network Watcher Configuration
# -----------------------------------------------------------------------------
variable "network_watcher_name" {
  description = "Name of the Network Watcher"
  type        = string
  default     = "nw-mgmt-prd-wus3-01"
}

# -----------------------------------------------------------------------------
# VNet Peering Configuration
# -----------------------------------------------------------------------------
variable "peering_mgmt_to_hub_name" {
  description = "Name of the VNet peering from Management to Hub"
  type        = string
  default     = "peer-mgmt-to-hub"
}

variable "peering_allow_virtual_network_access" {
  description = "Allow virtual network access through the peering"
  type        = bool
  default     = true
}

variable "peering_allow_forwarded_traffic" {
  description = "Allow forwarded traffic through the peering"
  type        = bool
  default     = true
}

variable "spoke_allow_gateway_transit" {
  description = "Allow gateway transit for spoke VNet (should be false for spoke side)"
  type        = bool
  default     = false
}

variable "spoke_use_remote_gateways" {
  description = "Use remote gateways for spoke VNet (enables use of hub's gateway - set false until hub gateway exists)"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Remote State Configuration
# -----------------------------------------------------------------------------
variable "remote_state_resource_group_name" {
  description = "Resource group name for the Terraform state storage account"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "remote_state_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "remote_state_container_name" {
  description = "Container name for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "remote_state_subscription_id" {
  description = "Subscription ID where the Terraform state storage account resides"
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
