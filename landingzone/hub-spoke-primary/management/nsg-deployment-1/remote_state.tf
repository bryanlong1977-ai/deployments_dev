# Remote State Data Sources for NSG Deployment 1 - Management Subscription
# References outputs from previous deployments

# Reference Management Network Deployment 1 for subnet IDs
data "terraform_remote_state" "management_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = "hub-spoke-primary/management/network-deployment-1.tfstate"
    subscription_id      = var.tfstate_subscription_id
    use_azuread_auth     = true
    use_msi              = true
  }
}