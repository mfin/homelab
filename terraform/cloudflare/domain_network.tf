data "cloudflare_zones" "network" {
  filter {
    name = data.sops_file.secrets.data["network.domain"]
  }
}

# manual overrides
#   - dnssec
