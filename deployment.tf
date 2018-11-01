# Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group_name}"
  location = "${var.deployment_region}"
}

# Storage Account
resource "azurerm_storage_account" "static_content_storage_account" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${azurerm_resource_group.resource_group.name}"
  location                 = "${var.deployment_region}"
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Hot"

  network_rules {
    virtual_network_subnet_ids = ["${azurerm_subnet.appgw_subnet.id}"]
  }
}

# Virtual Network
resource "azurerm_virtual_network" "virtual_network" {
  name                = "test-vnet"
  address_space       = "${var.virtual_network_address_space}"
  location            = "${var.deployment_region}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

# Application Gateway Subnet
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw-subnet"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
  address_prefix       = "${var.appgw_subnet_addr_prefix}"
  service_endpoints    = ["Microsoft.Storage"]
}

# Public IP for Application Gateway
resource "azurerm_public_ip" "appgw_public_ip" {
  name                         = "app-gw-public-ip"
  location                     = "${var.deployment_region}"
  resource_group_name          = "${azurerm_resource_group.resource_group.name}"
  domain_name_label            = "demo-storage"
  public_ip_address_allocation = "Dynamic"
}

# Create an application gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "application-gateway"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.deployment_region}"

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 1
  }

  ssl_certificate {
    name     = "ssl-cert"
    data     = "${base64encode(file("${var.ssl_cert_file}"))}"
    password = "${var.ssl_cert_password}"
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = "${azurerm_subnet.appgw_subnet.id}"
  }

  frontend_port {
    name = "frontend-https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-configuration"
    public_ip_address_id = "${azurerm_public_ip.appgw_public_ip.id}"
  }

  # HTTP Listener for Static Content (www)
  http_listener {
    name                           = "frontend-https-listener"
    frontend_ip_configuration_name = "frontend-ip-configuration"
    frontend_port_name             = "frontend-https-port"
    host_name                      = "${var.custom_domain_name}"
    ssl_certificate_name           = "ssl-cert"
    protocol                       = "Https"
  }

  # Backend pool
  backend_address_pool {
    name            = "frontend-backend-pool"
    ip_address_list = ["${var.storage_domain_name}"]
  }

  # HTTP Settings for Static Content
  backend_http_settings {
    name                  = "frontend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "frontend-probe"
  }

  probe {
    name                = "frontend-probe"
    protocol            = "Http"
    path                = "/"
    host                = "${var.storage_domain_name}"
    interval            = 10
    timeout             = 30
    unhealthy_threshold = 3
  }

  # Routing rule for Static Content
  request_routing_rule {
    name                       = "frontend-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "frontend-https-listener"
    backend_address_pool_name  = "frontend-backend-pool"
    backend_http_settings_name = "frontend-http-settings"
  }
}
