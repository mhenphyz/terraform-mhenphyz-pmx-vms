variable "telmate_pmx" {
  description = "Promox Telmate Provider Configuration Variable"
  sensitive   = true
  type = object({
    pm_api_url                  = string
    pm_user                     = optional(string)
    pm_password                 = optional(string)
    pm_api_token_id             = optional(string)
    pm_api_token_secret         = optional(string)
    pm_otp                      = optional(string)
    pm_tls_insecure             = optional(bool, false)
    pm_parallel                 = optional(number, 1)
    pm_log_enable               = optional(bool, false)
    pm_log_file                 = optional(string, "terraform-plugin-proxmox.log")
    pm_timeout                  = optional(number, 300)
    pm_debug                    = optional(bool, false)
    pm_proxy_server             = optional(string)
    pm_minimum_permission_check = optional(bool, true)
    pm_minimum_permission_list  = optional(list(string), [])
  })

  validation {
    condition     = can(regex("^https?://.+", var.telmate_pmx.pm_api_url))
    error_message = "The pm_api_url needs to be a valid URL starting with http or https"
  }

  validation {
    condition     = var.telmate_pmx.pm_timeout > 0
    error_message = "Timeout needs to be a positive number."
  }

  validation {
    condition     = var.telmate_pmx.pm_parallel >= 1
    error_message = "The number of simultaneous proxmox processes needs to be bigger than 1"
  }
}