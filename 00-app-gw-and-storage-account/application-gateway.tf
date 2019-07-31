# Create a managed identity to be used to access the certificate in the KeyVault
resource "azurerm_user_assigned_identity" "appgwidentity" {
  name = "${var.user_managed_identity}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.deployment_region}"
}

# Create an application gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "application-gateway"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  location            = "${var.deployment_region}"
  identity {
    identity_ids = ["${azurerm_user_assigned_identity.appgwidentity.id}"]
  }        

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  ssl_certificate {
    name     = "ssl-cert"
    data     = "${filebase64("${var.ssl_cert_file}")}" # terraform 0.12
    #data     = "${base64encode(file("${var.ssl_cert_file}"))}" # terraform 0.11
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
    host_name                      = "${var.public_dns_record}.${var.dns_zone_name}"
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
