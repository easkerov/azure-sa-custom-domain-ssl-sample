# Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.virtual_network_name}"
  address_space       = "${var.virtual_network_address_space}"
  location            = "${var.deployment_region}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

# NSG for the app gateway
resource "azurerm_network_security_group" "appgwnsg" {
  name                = "appgwnsg"
  location            = "${var.deployment_region}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  security_rule {
    name                       = "appgw"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NSG rule to allow all Inbound connections for testing, but can be changed as needed
resource "azurerm_network_security_rule" "appgwnsgrule" {
  name                        = "allowhttps"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.resource_group.name}"
  network_security_group_name = "${azurerm_network_security_group.appgwnsg.name}"
}

# Application Gateway Subnet
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw-subnet"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
  address_prefix       = "${var.appgw_subnet_addr_prefix}"
  service_endpoints    = ["Microsoft.Storage"]
}

# associate the NSG to the appgw subnet
resource "azurerm_subnet_network_security_group_association" "nsgappgwsubnet" {
  subnet_id                 = "${azurerm_subnet.appgw_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.appgwnsg.id}"
}

# Public IP for Application Gateway
resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "${var.public_ip_resource_name}"
  sku                 = "Standard"
  location            = "${var.deployment_region}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  domain_name_label   = "${var.public_ip_dns_name}"
  allocation_method   = "Static"
}
