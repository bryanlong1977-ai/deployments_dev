# Remote State for Management Network Deployment 1
data "terraform_remote_state" "network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    container_name       = var.remote_state_container_name
    key                  = "hub-spoke-primary/management/network-deployment-1.tfstate"
    subscription_id      = var.subscription_id
    use_azuread_auth     = true
  }
}

# Remote State for Identity Network Deployment 1 (Private DNS Zones)
data "terraform_remote_state" "identity_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    container_name       = var.remote_state_container_name
    key                  = "hub-spoke-primary/identity/network-deployment-1.tfstate"
    subscription_id      = var.subscription_id
    use_azuread_auth     = true
  }
}

# Remote State for Management Tools Deployment 1 (Log Analytics, Key Vaults, Managed Identity)
data "terraform_remote_state" "tools_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    container_name       = var.remote_state_container_name
    key                  = "hub-spoke-primary/management/tools-deployment-1.tfstate"
    subscription_id      = var.subscription_id
    use_azuread_auth     = true
  }
}