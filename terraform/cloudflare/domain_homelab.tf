data "cloudflare_zones" "homelab" {
  filter {
    name = data.sops_file.secrets.data["homelab.domain"]
  }
}

resource "cloudflare_zone_dnssec" "homelab" {
  zone_id = lookup(data.cloudflare_zones.homelab.zones[0], "id")
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

resource "cloudflare_record" "homelab_mx_primary" {
  name     = data.sops_file.secrets.data["homelab.domain"]
  zone_id  = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  value    = "in1-smtp.messagingengine.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_record" "homelab_mx_secondary" {
  name     = data.sops_file.secrets.data["homelab.domain"]
  zone_id  = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  value    = "in2-smtp.messagingengine.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 20
}

resource "cloudflare_record" "homelab_dmarc" {
  name     = "_dmarc"
  zone_id  = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  value    = "v=DMARC1; p=none; rua=mailto:dmarc@${data.sops_file.secrets.data["homelab.domain"]}"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "homelab_spf" {
  name     = data.sops_file.secrets.data["homelab.domain"]
  zone_id  = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  value    = "v=spf1 include:spf.messagingengine.com ?all"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "homelab_dkim_1" {
  name    = "fm1._domainkey"
  zone_id = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  value   = "fm1.${data.sops_file.secrets.data["homelab.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "homelab_dkim_2" {
  name    = "fm2._domainkey"
  zone_id = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  value   = "fm2.${data.sops_file.secrets.data["homelab.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "homelab_dkim_3" {
  name    = "fm3._domainkey"
  zone_id = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  value   = "fm3.${data.sops_file.secrets.data["homelab.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_filter" "homelab_github" {
  zone_id     = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  description = "Requests originating from Github"
  expression  = "(ip.geoip.asnum eq 36459)"
}

resource "cloudflare_firewall_rule" "homelab_github" {
  zone_id     = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  description = "Allow requests originating from Github"
  filter_id   = cloudflare_filter.homelab_github.id
  action      = "allow"
}

resource "cloudflare_filter" "homelab_countries" {
  zone_id     = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  description = "Requests originating from certain countries"
  expression  = "(not ip.geoip.country in {\"AT\" \"HR\" \"DE\" \"IT\" \"SI\"})"
}

resource "cloudflare_firewall_rule" "homelab_countries" {
  zone_id     = lookup(data.cloudflare_zones.homelab.zones[0], "id")
  description = "Block requests originating from certain countries"
  filter_id   = cloudflare_filter.homelab_countries.id
  action      = "block"
}

# manual overrides:
#   - strict ssl
#   - min tls version 1.2
#   - https rewrites
#   - auto minify
#   - http3
#   - websockets
#   - brotli
#   - rocket loader off
