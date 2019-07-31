variable "subscription_id" {
  type        = "string"
  description = "Azure Subscription Id"
}

variable "client_id" {
  type        = "string"
  description = "Azure Service Principal App Id"
}

variable "client_secret" {
  type        = "string"
  description = "Azure Service Principal Password"
}

variable "tenant_id" {
  type        = "string"
  description = "Azure Tenant Id"
}

variable "appgw_resource_group_name" {
  type        = "string"
  description = "Azure Resource Group Name"
}

variable "deployment_region" {
  type        = "string"
  description = "Region"
}

variable "storage_account_name" {
  type        = "string"
  description = "Storage Account Name"
}

variable "storage_domain_name" {
  type = "string"
}

variable "public_ip_dns_name" {
  type        = "string"
  description = "Public IP DNS Name"
}

variable "public_dns_record" {
  type = "string"
}

variable "dns_zone_name" {
  type = "string"
  description = "The domain name which will be created as a DNS zone for the app gateway"
}

variable "virtual_network_address_space" {
  type        = "list"
  description = "VNet Address Space"
}

variable "appgw_subnet_addr_prefix" {
  type        = "string"
  description = "Application Gateway Subnet Address Prefix"
}

variable "ssl_cert_file" {
  type        = "string"
  description = "SSL Certificate PFX file path"
}

variable "ssl_cert_password" {
  type        = "string"
  description = "SSL Certificate Password"
}

variable "my_client_public_ip" {
  type        = "string"
  description = "Your Public IP to be allowed on the Storage account"
}

variable "user_managed_identity" {
  type        = "string"
  description = "This will be the managed identity used by the AppGW to access the Keyvault"
}
