# Remote State References for Route Table Deployment 1 - Identity Subscription
# This deployment requires subnet IDs from Identity Network Deployment 1

data "terraform_remote_state" "identity_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    container_name       = var.remote_state_container_name
    key                  = "hub-spoke-primary/identity/network-deployment-1.tfstate"
    subscription_id      = var.subscription_id
    use_azuread_auth     = true
    use_msi              = false
  }
}