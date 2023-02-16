data "cloudflare_zones" "remote" {
  filter {
    name = data.sops_file.secrets.data["remote.domain"]
  }
}

resource "cloudflare_record" "remote_www" {
  name     = "www"
  zone_id  = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value    = "192.0.2.1"
  comment  = local.cf_comment
  proxied  = true
  type     = "A"
}

resource "cloudflare_record" "remote_root" {
  name     = data.sops_file.secrets.data["remote.domain"]
  zone_id  = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value    = data.sops_file.secrets.data["remote.tunnel"]
  comment  = local.cf_comment
  proxied  = true
  type     = "CNAME"
}
