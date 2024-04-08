data "azurerm_public_ip" "appgw" {
  name                = local.app_gateway_public_ip_name
  resource_group_name = local.resource_group_name_mgmt
}

data "azurerm_subnet" "gateway" {
  name                 = local.app_gateway_subnet_name
  virtual_network_name = local.app_gateway_vnet_name
  resource_group_name  = local.resource_group_name_mgmt
}

data "azurerm_user_assigned_identity" "appgw" {
  name                = local.user_assigned_identity_name
  resource_group_name = local.resource_group_name_mgmt
}

data "azurerm_container_app_environment" "env1" {
  name                = local.container_app_environment1_name
  resource_group_name = local.resource_group_name_aca_env1
}

data "azurerm_key_vault" "mgmt" {
  name                = local.key_vault_mgmt_name
  resource_group_name = local.resource_group_name_mgmt
}
