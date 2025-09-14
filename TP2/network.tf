#network.tf

resource "azurerm_network_security_group" "main-2" {
  name                = "network-security-group"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH-home"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" #"${var.my_public_ip}/32"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface_security_group_association" "main-2" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main-2.id
}