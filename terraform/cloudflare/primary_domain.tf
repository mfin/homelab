data "cloudflare_zones" "primary_domain" {
  filter {
    name = data.sops_file.secrets.data["primary_zone"]
  }
}

resource "cloudflare_record" "mx_main" {
  name     = data.sops_file.secrets.data["primary_zone"]
  zone_id  = lookup(data.cloudflare_zones.primary_domain.zones[0], "id")
  value    = "aspmx.l.google.com"
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 1
}

resource "cloudflare_record" "mx_secondary_1" {
  name     = data.sops_file.secrets.data["primary_zone"]
  zone_id  = lookup(data.cloudflare_zones.primary_domain.zones[0], "id")
  value    = "alt1.aspmx.l.google.com"
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 5
}

resource "cloudflare_record" "mx_secondary_2" {
  name     = data.sops_file.secrets.data["primary_zone"]
  zone_id  = lookup(data.cloudflare_zones.primary_domain.zones[0], "id")
  value    = "alt2.aspmx.l.google.com"
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 5
}

resource "cloudflare_record" "mx_tertiary_1" {
  name     = data.sops_file.secrets.data["primary_zone"]
  zone_id  = lookup(data.cloudflare_zones.primary_domain.zones[0], "id")
  value    = "aspmx2.googlemail.com"
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_record" "mx_tertiary_2" {
  name     = data.sops_file.secrets.data["primary_zone"]
  zone_id  = lookup(data.cloudflare_zones.primary_domain.zones[0], "id")
  value    = "aspmx3.googlemail.com"
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
}
