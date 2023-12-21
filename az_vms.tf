
# 6. Create public IPs for Web and BE

resource "azurerm_public_ip" "tf_pip_web" {
  name                = "${var.hostname}-web-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  tags                = var.tags
}

resource "azurerm_public_ip" "tf_pip_be" {
  name                = "${var.hostname}-be-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  tags                = var.tags
}


#
# 8. Create Network interface
# One NIC can be associated with multiple VMs, but only can be active only on 1 VM
#
resource "azurerm_network_interface" "tf_web_nic" {
  name                = "${var.hostname}-web-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.prefix}-web-ipconfig"
    subnet_id                     = azurerm_subnet.subnet-web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf_pip_web.id
  }
}

resource "azurerm_network_interface" "tf_be_nic" {
  name                = "${var.hostname}-be-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "${var.prefix}-be-ipconfig"
    subnet_id                     = azurerm_subnet.subnet-be.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf_pip_be.id
  }
}


#
# Create LinuxVM in Web subnet
#
resource "azurerm_linux_virtual_machine" "tf_webvm" {
  name                            = "${var.hostname}-${var.vm-type}-001"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false

  network_interface_ids = ["${azurerm_network_interface.tf_web_nic.id}"]

  tags = var.tags

  os_disk {
    name                 = "${var.hostname}_osdisk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}

#
# Create LinuxVM in be subnet
#
resource "azurerm_linux_virtual_machine" "tf_be_vm" {
  name                            = "${var.hostname}-${var.vm-type}-002"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false
  network_interface_ids           = ["${azurerm_network_interface.tf_be_nic.id}"]

  tags = var.tags

  os_disk {
    name                 = "${var.hostname}_be_osdisk"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }
}




/*
resource "azurerm_linuxvirtual_machine" "tf_webvm" {  

  name                = "${var.hostname}-${var.vm-type}-web-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vm_size             = var.vm_size



  network_interface_ids         = ["${azurerm_network_interface.tf_web_nic.id}"]
  delete_os_disk_on_termination = "true"


  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.hostname}_osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.vm_admin_username
    admin_password = var.vm_admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # This is to ensure SSH comes up before we run the local exec.
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My first Apache website using terraform in Azure</center></h1>' > index.html",
      "echo '<h1><center>Anand Ramasubramanian</center></h1>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.tf_pip_web.fqdn
      user     = var.admin_username
      password = var.admin_password

    }
  }

} */