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
  enable_https_traffic_only = true

  network_rules {
    virtual_network_subnet_ids = ["${azurerm_subnet.appgw_subnet.id}"]
  }

  provisioner "local-exec" {
    command = "az storage blob service-properties update --account-name ${var.storage_account_name} --subscription ${var.subscription_id} --static-website  --index-document index.html --404-document 404.html"
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
  sku                          = "Standard"
  location                     = "${var.deployment_region}"
  resource_group_name          = "${azurerm_resource_group.resource_group.name}"
  domain_name_label            = "${var.public_ip_dns_name}"
  allocation_method            = "Static"
}

# Create an application gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "application-gateway"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.deployment_region}"

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
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
    fqdns           = ["${var.storage_domain_name}"]
  }

  # HTTPS Settings for Static Content
  backend_http_settings {
    name                  = "frontend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 30
    probe_name            = "frontend-probe"
    pick_host_name_from_backend_address = true
  }

  probe {
    name                = "frontend-probe"
    protocol            = "Https"
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
