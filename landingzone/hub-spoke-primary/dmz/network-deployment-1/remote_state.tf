# =============================================================================
# Remote State Data Sources for DMZ Network Deployment 1
# =============================================================================

# -----------------------------------------------------------------------------
# Connectivity Network Deployment 1 - Hub VNet for peering
# -----------------------------------------------------------------------------
data "terraform_remote_state" "connectivity_network_deployment_1" {
  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_resource_group_name
    storage_account_name = var.remote_state_storage_account_name
    container_name       = var.remote_state_container_name
    key                  = var.connectivity_network_state_key
    subscription_id      = var.remote_state_subscription_id
    use_azuread_auth     = true
  }
}