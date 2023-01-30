data "cloudflare_zones" "public_domain" {
  filter {
    name = data.sops_file.secrets.data["cloudflare_homelab_zone"]
  }
}

resource "cloudflare_record" "unproxied_cname" {
  name    = data.sops_file.secrets.data["cloudflare_homelab_unproxied_cname"]
  zone_id = lookup(data.cloudflare_zones.public_domain.zones[0], "id")
  value   = data.sops_file.secrets.data["cloudflare_homelab_proxied"]
  proxied = false
  type    = "CNAME"
  ttl     = 1
}
