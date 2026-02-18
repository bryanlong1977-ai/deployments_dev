variable "subscription_id" {
  description = "The subscription ID where resources will be deployed"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
}

variable "region" {
  description = "The Azure region for resource deployment"
  type        = string
  default     = "East US 2"
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "rt-idm-prd-eus2-01"
}

variable "route_table_resource_group_name" {
  description = "Name of the resource group for the route table"
  type        = string
  default     = "rg-rt-idm-prd-eus2-01"
}

variable "vnet_name" {
  description = "Name of the Identity VNet"
  type        = string
  default     = "vnet-idm-prd-eus2-01"
}

variable "bgp_route_propagation_enabled" {
  description = "Enable or disable BGP route propagation"
  type        = bool
  default     = true
}

variable "default_route_name" {
  description = "Name of the default route to firewall"
  type        = string
  default     = "route-to-firewall"
}

variable "default_route_address_prefix" {
  description = "Address prefix for the default route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "default_route_next_hop_type" {
  description = "Next hop type for the default route"
  type        = string
  default     = "VirtualAppliance"
}

variable "firewall_lb_private_ip" {
  description = "Private IP address of the Azure Load Balancer for firewall in the Hub subscription"
  type        = string
  default     = "10.0.0.196"
}

variable "subnet_pe_name" {
  description = "Name of the private endpoints subnet"
  type        = string
  default     = "snet-pe-idm-eus2-01"
}

variable "subnet_tools_name" {
  description = "Name of the tools subnet"
  type        = string
  default     = "snet-tools-idm-eus2-01"
}

variable "subnet_inbound_name" {
  description = "Name of the DNS resolver inbound subnet"
  type        = string
  default     = "snet-inbound-idm-eus2-01"
}

variable "subnet_outbound_name" {
  description = "Name of the DNS resolver outbound subnet"
  type        = string
  default     = "snet-outbound-idm-eus2-01"
}

variable "subnet_dc_name" {
  description = "Name of the domain controllers subnet"
  type        = string
  default     = "snet-dc-idm-eus2-01"
}

variable "subnet_ib_mgmt_name" {
  description = "Name of the Infoblox management subnet"
  type        = string
  default     = "snet-ib-mgmt-idm-eus2-01"
}

variable "subnet_ib_lan1_name" {
  description = "Name of the Infoblox LAN1 subnet"
  type        = string
  default     = "snet-ib-lan1-idm-eus2-01"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    customer      = "Cloud AI Consulting"
    project       = "Secure Cloud Foundations"
    environment   = "Production"
    deployment_id = "7e6e79d1-70cd-4feb-8f93-d22e3f2f6fca"
    subscription  = "identity"
  }
}

# Remote state configuration variables
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

variable "tfstate_subscription_id" {
  description = "Subscription ID where Terraform state storage is located"
  type        = string
  default     = "53fea26b-011b-4520-b157-e31b034c7900"
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
