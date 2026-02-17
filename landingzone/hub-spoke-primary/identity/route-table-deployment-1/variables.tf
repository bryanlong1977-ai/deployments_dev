variable "subscription_id" {
  description = "The Azure subscription ID for the Identity subscription"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "West US 3"
}

variable "route_table_name" {
  description = "Name of the route table for the Identity VNet"
  type        = string
  default     = "rt-idm-prd-wus3-01"
}

variable "route_table_resource_group_name" {
  description = "Name of the resource group for the route table"
  type        = string
  default     = "rg-rt-idm-prd-wus3-01"
}

variable "vnet_name" {
  description = "Name of the Identity Virtual Network"
  type        = string
  default     = "vnet-idm-prd-wus3-01"
}

variable "bgp_route_propagation_enabled" {
  description = "Whether to enable BGP route propagation on the route table"
  type        = bool
  default     = false
}

variable "route_default_name" {
  description = "Name of the default route to firewall"
  type        = string
  default     = "route-to-firewall"
}

variable "route_default_address_prefix" {
  description = "Address prefix for the default route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "route_next_hop_type" {
  description = "The type of Azure hop the packet should be sent to"
  type        = string
  default     = "VirtualAppliance"
}

variable "firewall_lb_ip" {
  description = "The private IP address of the Azure Load Balancer for firewall in the Hub subscription"
  type        = string
  default     = "10.0.0.196"
}

variable "subnet_pe_name" {
  description = "Name of the Private Endpoints subnet"
  type        = string
  default     = "snet-pe-idm-wus3-01"
}

variable "subnet_tools_name" {
  description = "Name of the Tools subnet"
  type        = string
  default     = "snet-tools-idm-wus3-01"
}

variable "subnet_inbound_name" {
  description = "Name of the DNS Resolver Inbound subnet"
  type        = string
  default     = "snet-inbound-idm-wus3-01"
}

variable "subnet_outbound_name" {
  description = "Name of the DNS Resolver Outbound subnet"
  type        = string
  default     = "snet-outbound-idm-wus3-01"
}

variable "subnet_dc_name" {
  description = "Name of the Domain Controllers subnet"
  type        = string
  default     = "snet-dc-idm-wus3-01"
}

variable "subnet_ib_mgmt_name" {
  description = "Name of the Infoblox Management subnet"
  type        = string
  default     = "snet-ib-mgmt-idm-wus3-01"
}

variable "subnet_ib_lan1_name" {
  description = "Name of the Infoblox LAN1 subnet"
  type        = string
  default     = "snet-ib-lan1-idm-wus3-01"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "925e43c3-6edd-4030-9310-0f384ef3ac0b"
    subscription  = "identity"
  }
}

variable "tfstate_resource_group_name" {
  description = "Resource group name for Terraform state storage"
  type        = string
  default     = "rg-storage-ncus-01"
}

variable "tfstate_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = "sacloudaiconsulting01"
}

variable "tfstate_container_name" {
  description = "Container name for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "identity_network_state_key" {
  description = "State key for the Identity Network Deployment 1"
  type        = string
  default     = "hub-spoke-primary/identity/network-deployment-1.tfstate"
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
