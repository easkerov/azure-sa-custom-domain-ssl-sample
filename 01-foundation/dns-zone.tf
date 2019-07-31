resource "azurerm_dns_zone" "appgwdnszone" {
  name                = "${var.dns_zone_name}"
  resource_group_name = "${azurerm_resource_group.foundation_resource_group.name}"
  zone_type           = "Public"
}
resource "azurerm_dns_cname_record" "appcnamerecord" {
  name                = "${var.public_dns_record}"
  zone_name           = "${azurerm_dns_zone.appgwdnszone.name}"
  resource_group_name = "${azurerm_resource_group.foundation_resource_group.name}"
  ttl                 = 300
  record              = "${var.public_ip_dns_name}.${var.deployment_region}.cloudapp.azure.com" #This should point to the appGW Public IP DNS Name.
}
