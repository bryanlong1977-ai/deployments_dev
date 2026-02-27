# Landing Zone Shared Configuration - Cloud AI Consulting/Secure Cloud Foundations
# Generated: 2026-02-27T16:08:25.789146+00:00
# This single terraform.tfvars is shared by ALL deployment steps.
# Each deployment's variables.tf declares only the variables it needs
# and maps to this file via -var-file.

# ============================================
# Identity
# ============================================
customer_name  = "Cloud AI Consulting"
project_name   = "Secure Cloud Foundations"
environment    = "Production"
region         = "East US 2"
deployment_id  = "0a47530c-e8eb-4895-83bc-973e0d54a3b3"
secondary_region = "Central US"
regional_cidr = "10.0.0.0/16"
topology = "hub-spoke"
region_type = "primary"

# ============================================
# Subscriptions
# ============================================
connectivity_subscription_id = "81abf5a8-5c86-4ca7-8af8-8b3596a58d07"
identity_subscription_id = "53fea26b-011b-4520-b157-e31b034c7900"
management_subscription_id = "53fea26b-011b-4520-b157-e31b034c7900"

# ============================================
# VNet - Connectivity
# ============================================
connectivity_vnet_name = "vnet-hub-prd-eus2-01"
connectivity_vnet_address_space = "10.0.0.0/22"

# Subnets - Connectivity
connectivity_subnets = {
  snet-pe-hub-eus2-01 = {
    address_prefix = "10.0.0.0/26"
  }
  snet-tools-hub-eus2-01 = {
    address_prefix = "10.0.0.64/26"
  }
}

connectivity_subnet_cidrs = {
  "snet-pe-hub-eus2-01" = "10.0.0.0/26"
  "snet-tools-hub-eus2-01" = "10.0.0.64/26"
}

# ============================================
# VNet - Identity
# ============================================
identity_vnet_name = "vnet-idm-prd-eus2-01"
identity_vnet_address_space = "10.0.4.0/24"

# Subnets - Identity
identity_subnets = {
  snet-pe-idm-eus2-01 = {
    address_prefix = "10.0.4.0/26"
  }
  snet-tools-idm-eus2-01 = {
    address_prefix = "10.0.4.64/26"
  }
  snet-inbound-idm-eus2-01 = {
    address_prefix = "10.0.4.128/28"
  }
  snet-outbound-idm-eus2-01 = {
    address_prefix = "10.0.4.144/28"
  }
  snet-dc-idm-eus2-01 = {
    address_prefix = "10.0.4.160/27"
  }
}

identity_subnet_cidrs = {
  "snet-pe-idm-eus2-01" = "10.0.4.0/26"
  "snet-tools-idm-eus2-01" = "10.0.4.64/26"
  "snet-inbound-idm-eus2-01" = "10.0.4.128/28"
  "snet-outbound-idm-eus2-01" = "10.0.4.144/28"
  "snet-dc-idm-eus2-01" = "10.0.4.160/27"
}

# ============================================
# VNet - Management
# ============================================
management_vnet_name = "vnet-mgmt-prd-eus2-01"
management_vnet_address_space = "10.0.5.0/24"

# Subnets - Management
management_subnets = {
  snet-pe-mgmt-eus2-01 = {
    address_prefix = "10.0.5.0/26"
  }
  snet-tools-mgmt-eus2-01 = {
    address_prefix = "10.0.5.64/26"
  }
}

management_subnet_cidrs = {
  "snet-pe-mgmt-eus2-01" = "10.0.5.0/26"
  "snet-tools-mgmt-eus2-01" = "10.0.5.64/26"
}

# ============================================
# Resource Groups
# ============================================
resource_groups = {
  "Connectivity" = "rg-network-prd-hub-eus2-01"
  "Management" = "rg-network-prd-mgmt-eus2-01"
  "Identity" = "rg-network-prd-idm-eus2-01"
}
connectivity_resource_group_name = "rg-network-prd-hub-eus2-01"
management_resource_group_name = "rg-network-prd-mgmt-eus2-01"
identity_resource_group_name = "rg-network-prd-idm-eus2-01"

# ============================================
# Network Watchers
# ============================================
hub_network_watcher_name = "nw-hub-prd-eus2-01"
hub_network_watcher_resource_group = "rg-nw-prd-hub-eus2-01"
mgmt_network_watcher_name = "nw-mgmt-prd-eus2-01"
mgmt_network_watcher_resource_group = "rg-nw-prd-mgmt-eus2-01"

# ============================================
# Route Tables
# ============================================
connectivity_route_table_name = "rt-hub-prd-eus2-01"
connectivity_route_table_resource_group = "rg-rt-hub-prd-eus2-01"
identity_route_table_name = "rt-idm-prd-eus2-01"
identity_route_table_resource_group = "rg-rt-idm-prd-eus2-01"
management_route_table_name = "rt-mgmt-prd-eus2-01"
management_route_table_resource_group = "rg-rt-mgmt-prd-eus2-01"

# ============================================
# NSG Names
# ============================================
connectivity_nsg_resource_group = "rg-nsg-hub-prd-eus2-01"
connectivity_nsg_names = {
  "snet-pe-hub-eus2-01" = "nsg-hub-pe-prd-eus2-01"
  "snet-tools-hub-eus2-01" = "nsg-hub-tools-prd-eus2-01"
}
identity_nsg_resource_group = "rg-nsg-idm-prd-eus2-01"
identity_nsg_names = {
  "snet-pe-idm-eus2-01" = "nsg-idm-pe-prd-eus2-01"
  "snet-tools-idm-eus2-01" = "nsg-idm-tools-prd-eus2-01"
  "snet-inbound-idm-eus2-01" = "nsg-idm-inbound-prd-eus2-01"
  "snet-outbound-idm-eus2-01" = "nsg-idm-outbound-prd-eus2-01"
  "snet-dc-idm-eus2-01" = "nsg-idm-dc-prd-eus2-01"
}
management_nsg_resource_group = "rg-nsg-mgmt-prd-eus2-01"
management_nsg_names = {
  "snet-pe-mgmt-eus2-01" = "nsg-mgmt-pe-prd-eus2-01"
  "snet-tools-mgmt-eus2-01" = "nsg-mgmt-tools-prd-eus2-01"
}

# ============================================
# DNS Resources
# ============================================
private_dns_resolver_name = "pdr-identity-prd-eus2-01"
dns_inbound_endpoint_name = "drie-identity-prd-eus2-01"
dns_outbound_endpoint_name = "droe-identity-prd-eus2-01"
dns_resource_group = "rg-dns-prd-identity-eus2-01"
dns_subscription = "identity"
dns_forwarding_enabled = false

private_dns_zones = [
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
  "privatelink.disk.azure.net",
]

# ============================================
# VNet Peering Names
# ============================================
identity_to_hub_peering_name = "peer-idm-to-hub-prd-eus2-01"
hub_to_identity_peering_name = "peer-hub-to-idm-prd-eus2-01"
spoke_to_hub_peering_name = "peer-idm-to-hub-prd-eus2-01"
hub_to_spoke_peering_name = "peer-hub-to-idm-prd-eus2-01"
management_to_hub_peering_name = "peer-mgmt-to-hub-prd-eus2-01"
hub_to_management_peering_name = "peer-hub-to-mgmt-prd-eus2-01"

# ============================================
# Standard Deployment Resources
# ============================================
# Connectivity Subscription - Tools Deployment 1
hub_azure_monitor_private_link_scope_name = "mpls-hub-prd-eus2-01"
hub_azure_monitor_private_link_scope_resource_group = "rg-mpls-prd-hub-eus2-01"
hub_storage_account_vm_name = "saclouhubvmprdeus201"
hub_storage_account_vm_resource_group = "rg-st-prd-hub-eus2-01"
hub_storage_account_ntwk_name = "saclouhubntwkprdeus201"
hub_storage_account_ntwk_resource_group = "rg-st-prd-hub-eus2-01"

# Connectivity Subscription - NSG Deployment 1
hub_network_security_group_name = "nsg-hub-pe-prd-eus2-01"
hub_network_security_group_resource_group = "rg-nsg-hub-prd-eus2-01"

# Connectivity Subscription - Route Table Deployment 1
hub_route_table_name = "rt-hub-prd-eus2-01"
hub_route_table_resource_group = "rg-rt-hub-prd-eus2-01"

# Management Subscription - Tools Deployment 1
mgmt_key_vault_prd_name = "kvcloumgmtprdeus201"
mgmt_key_vault_prd_resource_group = "rg-kv-prd-mgmt-eus2-01"
mgmt_key_vault_nprd_name = "kvcloumgmtnprdeus201"
mgmt_key_vault_nprd_resource_group = "rg-kv-prd-mgmt-eus2-01"
mgmt_log_analytics_workspace_name = "law-mgmt-prd-eus2-01"
mgmt_log_analytics_workspace_resource_group = "rg-log-prd-mgmt-eus2-01"
mgmt_managed_identity_name = "mi-mgmt-prd-eus2-01"
mgmt_managed_identity_resource_group = "rg-mi-prd-mgmt-eus2-01"

# Management Subscription - Tools Deployment 2
mgmt_automation_account_name = "aa-mgmt-prd-eus2-01"
mgmt_automation_account_resource_group = "rg-aa-prd-mgmt-eus2-01"
mgmt_recovery_services_vault_name = "rsv-mgmt-prd-eus2-01"
mgmt_recovery_services_vault_resource_group = "rg-rsv-prd-mgmt-eus2-01"
mgmt_storage_account_vm_name = "sacloumgmtvmprdeus201"
mgmt_storage_account_vm_resource_group = "rg-st-prd-mgmt-eus2-01"
mgmt_storage_account_ntwk_name = "sacloumgmtntwkprdeus201"
mgmt_storage_account_ntwk_resource_group = "rg-st-prd-mgmt-eus2-01"

# Management Subscription - NSG Deployment 1
mgmt_network_security_group_name = "nsg-mgmt-pe-prd-eus2-01"
mgmt_network_security_group_resource_group = "rg-nsg-mgmt-prd-eus2-01"

# Management Subscription - Route Table Deployment 1
mgmt_route_table_name = "rt-mgmt-prd-eus2-01"
mgmt_route_table_resource_group = "rg-rt-mgmt-prd-eus2-01"

# Identity Subscription - Tools Deployment 1
idm_recovery_services_vault_name = "rsv-idm-prd-eus2-01"
idm_recovery_services_vault_resource_group = "rg-rsv-prd-idm-eus2-01"
idm_storage_account_vm_name = "saclouidmvmprdeus201"
idm_storage_account_vm_resource_group = "rg-st-prd-idm-eus2-01"
idm_storage_account_ntwk_name = "saclouidmntwkprdeus201"
idm_storage_account_ntwk_resource_group = "rg-st-prd-idm-eus2-01"

# Identity Subscription - NSG Deployment 1
idm_network_security_group_name = "nsg-idm-pe-prd-eus2-01"
idm_network_security_group_resource_group = "rg-nsg-idm-prd-eus2-01"

# Identity Subscription - Route Table Deployment 1
idm_route_table_name = "rt-idm-prd-eus2-01"
idm_route_table_resource_group = "rg-rt-idm-prd-eus2-01"

snet_pe_hub_eus2_01_subnet_name = "snet-pe-hub-eus2-01"
snet_tools_hub_eus2_01_subnet_name = "snet-tools-hub-eus2-01"

# Network Watcher - connectivity - Network Deployment 1
connectivity_network_watcher_name = "nw-hub-prd-eus2-01"
connectivity_network_watcher_resource_group = "rg-nw-prd-hub-eus2-01"
snet_pe_idm_eus2_01_subnet_name = "snet-pe-idm-eus2-01"
snet_tools_idm_eus2_01_subnet_name = "snet-tools-idm-eus2-01"
snet_inbound_idm_eus2_01_subnet_name = "snet-inbound-idm-eus2-01"
snet_outbound_idm_eus2_01_subnet_name = "snet-outbound-idm-eus2-01"
snet_dc_idm_eus2_01_subnet_name = "snet-dc-idm-eus2-01"
snet_pe_mgmt_eus2_01_subnet_name = "snet-pe-mgmt-eus2-01"
snet_tools_mgmt_eus2_01_subnet_name = "snet-tools-mgmt-eus2-01"

# Network Watcher - management - Network Deployment 1
management_network_watcher_name = "nw-mgmt-prd-eus2-01"
management_network_watcher_resource_group = "rg-nw-prd-mgmt-eus2-01"

# ============================================
# Feature Flags
# ============================================
enable_firewall    = true
enable_vpn_gateway = false
enable_bastion     = false
enable_route_server    = false
enable_dmz_spoke       = false
enable_infoblox        = false
enable_hub_internal_lb = false
enable_dmz_external_lb = false
enable_secondary_region = false
enable_epic_separation = false
mgmt_vnet_cidr = "10.0.5.0/24"
identity_vnet_cidr = "10.0.4.0/24"

# ============================================
# Tags
# ============================================
tags = {
  Customer    = "Cloud AI Consulting"
  Project     = "Secure Cloud Foundations"
  Environment = "Production"
  ManagedBy   = "Terraform"
  CreatedBy   = "CloudCraft"
}