variable "pve_api_url" {
  type        = string
  description = "The URL of the Proxmox API"
}
  
variable "pve_token_id" {
  type        = string
  description = "The token ID for the Proxmox API"
}

variable "pve_token_secret" {
  type        = string
  description = "The token secret for the Proxmox API"
}
