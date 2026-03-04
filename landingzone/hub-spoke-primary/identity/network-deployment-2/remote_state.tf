# =============================================================================
# Remote State - Connectivity Network Deployment 1
# (Network Watcher for flow logs)
# =============================================================================
data "terraform_remote_state" "connectivity_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/connectivity/network-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
    use_msi              = true
  }
}

# =============================================================================
# Remote State - Identity Network Deployment 1
# (VNet ID, Resource Group Name, Subnet IDs)
# =============================================================================
data "terraform_remote_state" "identity_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/identity/network-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
    use_msi              = true
  }
}

# =============================================================================
# Remote State - Management Tools Deployment 1
# (Log Analytics Workspace, Storage Account for diagnostics and flow logs)
# =============================================================================
data "terraform_remote_state" "management_tools_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-storage-ncus-01"
    storage_account_name = "sacloudaiconsulting01"
    container_name       = "tfstate"
    key                  = "hub-spoke-primary/management/tools-deployment-1.tfstate"
    subscription_id      = "53fea26b-011b-4520-b157-e31b034c7900"
    use_azuread_auth     = true
    use_msi              = true
  }
}
