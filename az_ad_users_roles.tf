# data source to access information about an existing Subscription
# https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/data-sources/subscription
# id, subscription_id, display_name, tenant_id, state, location_placement_id, quota_id, spending_limit, tags
data "azurerm_subscription" "current" {
}

# data source to access the configuration of the AzureRM provider
# https://registry.terraform.io/providers/hashicorp/Azurerm/latest/docs/data-sources/client_config
# client_id, tenant_id, subscription_id, object_id
data "azurerm_client_config" "current" {
}

# Retrieve domain information
data "azuread_domains" "default" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.default.domains.0.domain_name
}

resource "azurerm_role_definition" "custom" {
  name        = "${var.prefix}CustomOnboardRole"
  scope       = data.azurerm_subscription.current.id
  description = "Can start or restart virtual machines and read storage/network/subscriptions"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Storage/storageAccounts/blobServices/containers/read",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/read"
    ]
    data_actions     = ["Microsoft.Compute/virtualMachines/login/action"]
    not_actions      = []
    not_data_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id
  ]
}

#
# Add onboarded user and assign him custom role with least privilege 
#
resource "azuread_user" "new-users" {
  user_principal_name   = "testuser1@${local.domain_name}"
  display_name          = "Anand Test"
  mail_nickname         = "testuser1"
  department            = "IT Manager"
  password              = var.vm_admin_password
  force_password_change = true
}
resource "azurerm_role_assignment" "role-assignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.custom.role_definition_resource_id
  #role_definition_id = "Contributor"
  principal_id = azuread_user.new-users.id
}



#
# Add IT support user and assign him custom role with least privilege 
#
/*
resource "azuread_user" "new-support-users" {
  for_each = {for idx, user in local.users: idx => user}

  user_principal_name = "${each.value[0]}@${local.domain_name}"
  display_name        = each.value[1]
  mail_nickname       = each.value[0]
  department          = each.value[2]
  password            = var.vm_admin_password
  force_password_change = true
}

resource "azurerm_role_assignment" "support-role-assignment" {
  #for_each = {for idx, user in local.users: idx => user}
  for_each = {for u in azuread_user.users: u.mail_nickname => u if u.department == "IT Support" }  

  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.custom.role_definition_resource_id  
  principal_id       = each.value.id
}
*/