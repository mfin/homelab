data "cloudflare_zones" "network" {
  filter {
    name = data.sops_file.secrets.data["network.domain"]
  }
}

resource "cloudflare_zone_dnssec" "network" {
  zone_id = lookup(data.cloudflare_zones.network.zones[0], "id")
}
