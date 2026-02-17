# =============================================================================
# Remote State Data Sources
# =============================================================================

# Reference Identity Network Deployment 1 for VNet and Network Watcher
data "terraform_remote_state" "identity_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = "hub-spoke-primary/identity/network-deployment-1.tfstate"
    subscription_id      = var.tfstate_subscription_id
    use_azuread_auth     = true
  }
}

# Reference Management Tools Deployment 1 for Log Analytics Workspace
data "terraform_remote_state" "management_tools_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = "hub-spoke-primary/management/tools-deployment-1.tfstate"
    subscription_id      = var.tfstate_subscription_id
    use_azuread_auth     = true
  }
}

# Reference Identity Tools Deployment 1 for Network Storage Account
data "terraform_remote_state" "identity_tools_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = "hub-spoke-primary/identity/tools-deployment-1.tfstate"
    subscription_id      = var.tfstate_subscription_id
    use_azuread_auth     = true
  }
}