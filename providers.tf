terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url                  = var.telmate_pmx.pm_api_url
  pm_user                     = var.telmate_pmx.pm_user
  pm_password                 = var.telmate_pmx.pm_password
  pm_api_token_id             = var.telmate_pmx.pm_api_token_id
  pm_api_token_secret         = var.telmate_pmx.pm_api_token_secret
  pm_otp                      = var.telmate_pmx.pm_otp
  pm_tls_insecure             = var.telmate_pmx.pm_tls_insecure
  pm_parallel                 = var.telmate_pmx.pm_parallel
  pm_log_enable               = var.telmate_pmx.pm_log_enable
  pm_log_file                 = var.telmate_pmx.pm_log_file
  pm_timeout                  = var.telmate_pmx.pm_timeout
  pm_debug                    = var.telmate_pmx.pm_debug
  pm_proxy_server             = var.telmate_pmx.pm_proxy_server
  pm_minimum_permission_check = var.telmate_pmx.pm_minimum_permission_check
  pm_minimum_permission_list  = var.telmate_pmx.pm_minimum_permission_list
}
