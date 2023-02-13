data "cloudflare_zones" "homelab_domain" {
  filter {
    name = data.sops_file.secrets.data["homelab_zone"]
  }
}

resource "cloudflare_record" "homelab_unproxied" {
  name    = data.sops_file.secrets.data["homelab_proxied"]
  zone_id = lookup(data.cloudflare_zones.homelab_domain.zones[0], "id")
  value   = data.sops_file.secrets.data["homelab_unproxied"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
}
