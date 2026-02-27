# ============================================
# Subscription
# ============================================

variable "management_subscription_id" {
  type        = string
  description = "The subscription ID for the Management subscription."
}

# ============================================
# Identity / Metadata
# ============================================

variable "region" {
  type        = string
  description = "Primary Azure region for resource deployment."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
}

# ============================================
# Log Analytics Workspace
# ============================================

variable "mgmt_log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics Workspace."
}

variable "mgmt_log_analytics_workspace_resource_group" {
  type        = string
  description = "Resource group name for the Log Analytics Workspace."
}

# ============================================
# Key Vault - Production
# ============================================

variable "mgmt_key_vault_prd_name" {
  type        = string
  description = "Name of the production Key Vault."
}

variable "mgmt_key_vault_prd_resource_group" {
  type        = string
  description = "Resource group name for the production Key Vault."
}

# ============================================
# Key Vault - Non-Production
# ============================================

variable "mgmt_key_vault_nprd_name" {
  type        = string
  description = "Name of the non-production Key Vault."
}

variable "mgmt_key_vault_nprd_resource_group" {
  type        = string
  description = "Resource group name for the non-production Key Vault (shares RG with prd)."
}

# ============================================
# Managed Identity
# ============================================

variable "mgmt_managed_identity_name" {
  type        = string
  description = "Name of the user-assigned managed identity."
}

variable "mgmt_managed_identity_resource_group" {
  type        = string
  description = "Resource group name for the managed identity."
}

# ============================================
# Subnet Name References
# ============================================

variable "snet_pe_mgmt_eus2_01_subnet_name" {
  type        = string
  description = "Name of the private endpoint subnet in the management VNet."
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
  description = "Deployment environment (production, staging, development)"
  type        = string
}

variable "deployment_id" {
  description = "Unique deployment identifier for tagging and tracking"
  type        = string
}

variable "enable_firewall" {
  description = "Enable Azure Firewall in the hub VNet"
  type        = bool
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway for hybrid connectivity"
  type        = bool
}

variable "enable_bastion" {
  description = "Enable Azure Bastion for secure VM access"
  type        = bool
}

# ============================================
# REVIEW REQUIRED: Orphaned variable declarations
# These variables were used in main.tf but are not in shared
# terraform.tfvars. Update main.tf to use canonical variable names.
# ============================================

# NOTE: var.keyvault_dns_zone_name is not in shared terraform.tfvars.
# Replace with the correct canonical variable name from the tfvars file.
variable "keyvault_dns_zone_name" {
  description = "REVIEW: This variable is not defined in shared terraform.tfvars"
  type        = any
  default     = null
}

# NOTE: var.log_analytics_retention_days is not in shared terraform.tfvars.
# Replace with the correct canonical variable name from the tfvars file.
variable "log_analytics_retention_days" {
  description = "REVIEW: This variable is not defined in shared terraform.tfvars"
  type        = any
  default     = null
}

# NOTE: var.log_analytics_sku is not in shared terraform.tfvars.
# Replace with the correct canonical variable name from the tfvars file.
variable "log_analytics_sku" {
  description = "REVIEW: This variable is not defined in shared terraform.tfvars"
  type        = any
  default     = null
}

# ---------------------------------------------------------------------------
# Auto-declared stubs: variables present in the shared terraform.tfvars
# but not actively used by this deployment module.  Declared here to
# suppress "Value for undeclared variable" warnings from Terraform.
# ---------------------------------------------------------------------------
variable "CreatedBy" { default = null }
variable "Customer" { default = null }
variable "Environment" { default = null }
variable "ManagedBy" { default = null }
variable "Project" { default = null }
variable "address_prefix" { default = null }
variable "connectivity_network_watcher_name" { default = null }
variable "connectivity_network_watcher_resource_group" { default = null }
variable "connectivity_nsg_names" { default = null }
variable "connectivity_nsg_resource_group" { default = null }
variable "connectivity_resource_group_name" { default = null }
variable "connectivity_route_table_name" { default = null }
variable "connectivity_route_table_resource_group" { default = null }
variable "connectivity_subnet_cidrs" { default = null }
variable "connectivity_subnets" { default = null }
variable "connectivity_subscription_id" { default = null }
variable "connectivity_vnet_address_space" { default = null }
variable "connectivity_vnet_name" { default = null }
variable "dns_forwarding_enabled" { default = null }
variable "dns_inbound_endpoint_name" { default = null }
variable "dns_outbound_endpoint_name" { default = null }
variable "dns_resource_group" { default = null }
variable "dns_subscription" { default = null }
variable "enable_dmz_external_lb" { default = null }
variable "enable_dmz_spoke" { default = null }
variable "enable_epic_separation" { default = null }
variable "enable_hub_internal_lb" { default = null }
variable "enable_infoblox" { default = null }
variable "enable_route_server" { default = null }
variable "enable_secondary_region" { default = null }
variable "hub_azure_monitor_private_link_scope_name" { default = null }
variable "hub_azure_monitor_private_link_scope_resource_group" { default = null }
variable "hub_network_security_group_name" { default = null }
variable "hub_network_security_group_resource_group" { default = null }
variable "hub_network_watcher_name" { default = null }
variable "hub_network_watcher_resource_group" { default = null }
variable "hub_route_table_name" { default = null }
variable "hub_route_table_resource_group" { default = null }
variable "hub_storage_account_ntwk_name" { default = null }
variable "hub_storage_account_ntwk_resource_group" { default = null }
variable "hub_storage_account_vm_name" { default = null }
variable "hub_storage_account_vm_resource_group" { default = null }
variable "hub_to_identity_peering_name" { default = null }
variable "hub_to_management_peering_name" { default = null }
variable "hub_to_spoke_peering_name" { default = null }
variable "identity_nsg_names" { default = null }
variable "identity_nsg_resource_group" { default = null }
variable "identity_resource_group_name" { default = null }
variable "identity_route_table_name" { default = null }
variable "identity_route_table_resource_group" { default = null }
variable "identity_subnet_cidrs" { default = null }
variable "identity_subnets" { default = null }
variable "identity_subscription_id" { default = null }
variable "identity_to_hub_peering_name" { default = null }
variable "identity_vnet_address_space" { default = null }
variable "identity_vnet_cidr" { default = null }
variable "identity_vnet_name" { default = null }
variable "idm_network_security_group_name" { default = null }
variable "idm_network_security_group_resource_group" { default = null }
variable "idm_recovery_services_vault_name" { default = null }
variable "idm_recovery_services_vault_resource_group" { default = null }
variable "idm_route_table_name" { default = null }
variable "idm_route_table_resource_group" { default = null }
variable "idm_storage_account_ntwk_name" { default = null }
variable "idm_storage_account_ntwk_resource_group" { default = null }
variable "idm_storage_account_vm_name" { default = null }
variable "idm_storage_account_vm_resource_group" { default = null }
variable "management_network_watcher_name" { default = null }
variable "management_network_watcher_resource_group" { default = null }
variable "management_nsg_names" { default = null }
variable "management_nsg_resource_group" { default = null }
variable "management_resource_group_name" { default = null }
variable "management_route_table_name" { default = null }
variable "management_route_table_resource_group" { default = null }
variable "management_subnet_cidrs" { default = null }
variable "management_subnets" { default = null }
variable "management_to_hub_peering_name" { default = null }
variable "management_vnet_address_space" { default = null }
variable "management_vnet_name" { default = null }
variable "mgmt_automation_account_name" { default = null }
variable "mgmt_automation_account_resource_group" { default = null }
variable "mgmt_network_security_group_name" { default = null }
variable "mgmt_network_security_group_resource_group" { default = null }
variable "mgmt_network_watcher_name" { default = null }
variable "mgmt_network_watcher_resource_group" { default = null }
variable "mgmt_recovery_services_vault_name" { default = null }
variable "mgmt_recovery_services_vault_resource_group" { default = null }
variable "mgmt_route_table_name" { default = null }
variable "mgmt_route_table_resource_group" { default = null }
variable "mgmt_storage_account_ntwk_name" { default = null }
variable "mgmt_storage_account_ntwk_resource_group" { default = null }
variable "mgmt_storage_account_vm_name" { default = null }
variable "mgmt_storage_account_vm_resource_group" { default = null }
variable "mgmt_vnet_cidr" { default = null }
variable "private_dns_resolver_name" { default = null }
variable "private_dns_zones" { default = null }
variable "region_type" { default = null }
variable "regional_cidr" { default = null }
variable "resource_groups" { default = null }
variable "secondary_region" { default = null }
variable "snet_dc_idm_eus2_01_subnet_name" { default = null }
variable "snet_inbound_idm_eus2_01_subnet_name" { default = null }
variable "snet_outbound_idm_eus2_01_subnet_name" { default = null }
variable "snet_pe_hub_eus2_01_subnet_name" { default = null }
variable "snet_pe_idm_eus2_01_subnet_name" { default = null }
variable "snet_tools_hub_eus2_01_subnet_name" { default = null }
variable "snet_tools_idm_eus2_01_subnet_name" { default = null }
variable "snet_tools_mgmt_eus2_01_subnet_name" { default = null }
variable "spoke_to_hub_peering_name" { default = null }
variable "topology" { default = null }
