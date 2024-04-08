variable "location" {
  description = "The location of the Applications Gateway."
  type        = string
}

variable "location_short" {
  description = "The location short found at the end of each reosurce name, e.g. 'euw'."
  type        = string
}

variable "subscription_spec" {
  description = "The three unique characters of your subscription."
  type        = string
}

variable "host_name" {
  description = "The host name where you will be able to reach your app. It must match your certificate."
  type        = string
}

variable "app_fqdn" {
  description = "The FQDN of your app. Remove 'https://' from Application URL to get your FQDN."
  type        = string
}

variable "certificate_name" {
  description = "The name of the SSL certificate lying in the mgmt key vault"
  type        = string
}

############################################################################################################################################################################
# Optional 'Static' Default Variables
############################################################################################################################################################################

variable "sku" {
  description = "The sku block of the Application Gateway. For more information see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway"
  type = object({
    capacity = number
    name     = string
    tier     = string
  })
  default = {
    capacity = 1
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }
}

variable "waf_configuration" {
  description = "The waf_configuration block of the Application Gateway. For more information see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway"
  type = object({
    enabled                  = bool
    firewall_mode            = string
    rule_set_type            = optional(string)
    rule_set_version         = string
    disabled_rule_group      = optional(list(string))
    file_upload_limit_mb     = optional(number)
    request_body_check       = optional(bool)
    max_request_body_size_kb = optional(number)
    exclusion                = optional(list(string))
  })
  default = {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}