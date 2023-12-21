variable "prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "randcorp"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "eastus"
}

variable "hostname" {
  description = "Virtual machine hostname. Used for local hostname, DNS, and storage-related names."
  default     = "vm-test"
}

##
## Linux Virtual Machine Specifications
##

variable "vm-type" {
  description = "Virtual machine type. Used to specify type of Linux or Windows VM."
  default     = "linux-vm"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D2s_v3"
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "22_04-lts"
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "vm_admin_username" {
  description = "Username must only contain letters, numbers, hyphens, and underscores and may not start with a hyphen or number. The value is in between 1 and 64 characters long."
  default     = "azureadmin"
}

variable "vm_admin_password" {
  description = "Username must only contain letters, numbers, hyphens, and underscores and may not start with a hyphen or number. The value is in between 1 and 64 characters long."
  default     = "azure-admin$104"
}

#
# Azure Subscription, tenent
#
variable "tenant_id" {
  description = "The tenantId"
  default     = "110458cf-bec0-44ed-b15e-0658edf1c1f8"
}

variable "subscription_id" {
  description = "The subscriptionId"
  default     = "87948765-5c07-4a92-819f-251defd8eefd"
}

variable "custom_email" {
  description = "Notification email for onboarded user"
  default     = "rand_test_user1@simplilearnhol19.onmicrosoft.com"
}

#
# User(s) List
#
locals {
  users = [
    [
      "user1",
      "Test User1",
      "IT Support",
    ],
    [
      "user2",
      "Test User2",
      "IT Support"
    ]
  ]
}

# 
# Common
#
variable "tags" {
  type = map(any)

  default = {
    env    = "tst"
    Source = "Terraform"
    Dept   = "Engineering"
    Owner  = "Anand Ramasubramanian"
    email  = "ramasubramanian.anand@gmail.com"
  }
}

/* variable "env" {
  description = "The environment where this resource is created"
  default     = "tst"
} */



