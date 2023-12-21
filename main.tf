
# 1. Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-${var.location}-${var.tags.env}"
  location = var.location
  tags     = var.tags
}

# 2. Create two virtual network(s) within the resource group
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet-${var.prefix}-${var.location}-01"
  address_space       = ["10.10.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vnet-${var.prefix}-${var.location}-02"
  address_space       = ["10.20.0.0/16"]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}


# 3. Create 1 subnet each in vnet1 & vnet2 
resource "azurerm_subnet" "subnet-web" {
  name                 = "snet-web-${var.location}-01"
  address_prefixes     = ["10.10.0.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name

}

resource "azurerm_subnet" "subnet-be" {
  name                 = "snet-be-${var.location}-01"
  address_prefixes     = ["10.20.0.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name

}

# 4. Create Network Security Group and security rule(s)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.prefix}-${var.location}-weballow"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# 5. Associate the NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "web-nsg-association" {
  subnet_id                 = azurerm_subnet.subnet-web.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# 6. Create peering connection between two vnets
resource "azurerm_virtual_network_peering" "vnet1" {
  name                      = "${var.prefix}-peer1to2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "vnet2" {
  name                      = "${var.prefix}-peer2to1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}
