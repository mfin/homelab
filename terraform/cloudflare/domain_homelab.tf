data "cloudflare_zones" "homelab" {
  filter {
    name = data.sops_file.secrets.data["homelab.domain"]
  }
}

resource "cloudflare_record" "homelab_unproxied" {
  name    = data.sops_file.secrets.data["homelab.unproxied"]
  zone_id = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  value   = data.sops_file.secrets.data["homelab.proxied"]
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}
