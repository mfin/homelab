data "cloudflare_zones" "personal" {
  filter {
    name = data.sops_file.secrets.data["personal.domain"]
  }
}

resource "cloudflare_record" "personal_root" {
  name     = data.sops_file.secrets.data["personal.domain"]
  zone_id  = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value    = data.sops_file.secrets.data["personal.page"]
  comment  = local.cf_comment
  proxied  = true
  type     = "CNAME"
}

resource "cloudflare_record" "personal_www" {
  name     = "www"
  zone_id  = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value    = data.sops_file.secrets.data["personal.page"]
  comment  = local.cf_comment
  proxied  = true
  type     = "CNAME"
}
