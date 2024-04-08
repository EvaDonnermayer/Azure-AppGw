locals {
  gateway_subnet_id          = data.azurerm_subnet.gateway.id
  app_gateway_public_ip_id   = data.azurerm_public_ip.appgw.id
  user_assigned_identity_ids = [data.azurerm_user_assigned_identity.appgw.id]

  resource_group_name_mgmt        = "rg-mgmt-${var.subscription_spec}-${var.location_short}"
  resource_group_name_aca_env1    = "rg-aca-env1-${var.subscription_spec}-${var.location_short}"
  app_gateway_public_ip_name      = "pip-agw-mgmt-${var.subscription_spec}-${var.location_short}"
  app_gateway_subnet_name         = "gateway-subnet"
  app_gateway_vnet_name           = "vnet-mgmt-${var.subscription_spec}-${var.location_short}"
  user_assigned_identity_name     = "mi-appgw-mgmt-${var.subscription_spec}-${var.location_short}"
  app_gateway_name                = "agw-mgmt-${var.subscription_spec}-${var.location_short}"
  container_app_environment1_name = "ae-env1-${var.subscription_spec}-${var.location_short}"
  key_vault_mgmt_name             = "kv-mgmt-${var.subscription_spec}-${var.location_short}"
}