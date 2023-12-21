output "vm_public_ip" {
  value       = azurerm_public_ip.tf_pip_web.ip_address
  description = "The Public IP address of the web server instance."
}

output "vm_fqdn" {
  value = azurerm_public_ip.tf_pip_web.fqdn
}

/*
output "ssh_command" {
  value = "ssh ${var.vm_admin_username}@${azurerm_public_ip.tf_pip_web.fqdn}"
}
*/

output "CurrentSubscriptionId" {
  description = "Output current subscription id"
  value       = data.azurerm_subscription.current.id
}

output "Email_Onboarded_User" {
  description = "Email from onboarded user"
  value       = azuread_user.new-users.user_principal_name
}

output "domain_name" {
  description = "Domain name"
  value       = local.domain_name
}