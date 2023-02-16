data "cloudflare_zones" "business" {
  filter {
    name = data.sops_file.secrets.data["business.domain"]
  }
}

resource "cloudflare_record" "business_root" {
  name     = data.sops_file.secrets.data["business.domain"]
  zone_id  = lookup(data.cloudflare_zones.business.zones[0], "id")
  value    = data.sops_file.secrets.data["business.page"]
  comment  = local.cf_comment
  proxied  = true
  type     = "CNAME"
}

resource "cloudflare_record" "business_www" {
  name     = "www"
  zone_id  = lookup(data.cloudflare_zones.business.zones[0], "id")
  value    = data.sops_file.secrets.data["business.page"]
  comment  = local.cf_comment
  proxied  = true
  type     = "CNAME"
}
