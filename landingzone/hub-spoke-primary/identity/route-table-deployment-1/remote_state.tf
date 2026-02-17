# Remote state reference for Identity Network Deployment 1
# Used to get subnet IDs for route table associations
data "terraform_remote_state" "identity_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.tfstate_resource_group_name
    storage_account_name = var.tfstate_storage_account_name
    container_name       = var.tfstate_container_name
    key                  = var.identity_network_state_key
    subscription_id      = var.subscription_id
    use_azuread_auth     = true
  }
}