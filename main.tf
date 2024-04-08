terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.90.0"
    }
  }
  required_version = ">= 1.0.4"
}

provider "azurerm" {
  skip_provider_registration = "true"
  use_oidc                   = true
  features {}
}


resource "azurerm_application_gateway" "main" {
  name                = local.app_gateway_name
  resource_group_name = local.resource_group_name_mgmt
  location            = var.location

  sku {
    capacity = var.sku.capacity
    name     = var.sku.name
    tier     = var.sku.tier
  }

  waf_configuration {
    enabled          = var.waf_configuration.enabled
    firewall_mode    = var.waf_configuration.firewall_mode
    rule_set_type    = var.waf_configuration.rule_set_type
    rule_set_version = var.waf_configuration.rule_set_version
  }

  frontend_ip_configuration {
    name                 = "appGatewayPublicFrontendIp"
    public_ip_address_id = local.app_gateway_public_ip_id
  }

  frontend_port {
    name = "appGatewayFrontendPortHttp"
    port = 80
  }

  frontend_port {
    name = "appGatewayFrontendPortHttps"
    port = 443
  }

  gateway_ip_configuration {
    name      = "appGatewayFrontendIP"
    subnet_id = local.gateway_subnet_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = local.user_assigned_identity_ids
  }

  http_listener {
    name                           = "appGatewayHttpListener"
    frontend_ip_configuration_name = "appGatewayPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPortHttp"
    host_names                     = []
    protocol                       = "Http"
    require_sni                    = false
  }

  http_listener {
    name                           = "appGatewayHttpsListener"
    frontend_ip_configuration_name = "appGatewayPublicFrontendIp"
    frontend_port_name             = "appGatewayFrontendPortHttps"
    host_names                     = [var.host_name]
    ssl_certificate_name           = var.certificate_name
    protocol                       = "Https"
    require_sni                    = false
  }

  backend_address_pool {
    name         = local.container_app_environment1_name
    ip_addresses = [data.azurerm_container_app_environment.env1.static_ip_address]
  }

  backend_http_settings {
    name                           = "App1"
    affinity_cookie_name           = "ApplicationGatewayAffinity"
    cookie_based_affinity          = "Disabled"
    host_name                      = var.app_fqdn
    port                           = 443
    protocol                       = "Https"
    request_timeout                = 60
    trusted_root_certificate_names = []
  }

  request_routing_rule {
    name                       = "App1"
    http_listener_name         = "appGatewayHttpsListener"
    backend_address_pool_name  = local.container_app_environment1_name
    backend_http_settings_name = "App1"
    priority                   = 100
    rule_type                  = "Basic"
  }

  ssl_certificate {
    name                = var.certificate_name
    key_vault_secret_id = "${data.azurerm_key_vault.mgmt.vault_uri}secrets/${var.certificate_name}"
  }

  lifecycle {
    ignore_changes = [waf_configuration, sku, force_firewall_policy_association, frontend_port, fips_enabled, enable_http2, tags]
  }
}