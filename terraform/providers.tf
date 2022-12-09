terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pve_api_url
  pm_api_token_id     = var.pve_token_id
  pm_api_token_secret = var.pve_token_secret
  pm_log_enable       = false
  pm_log_file         = "terraform-plugin-proxmox.log"
  pm_parallel         = 1
  pm_timeout          = 600
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
