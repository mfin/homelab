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

resource "cloudflare_record" "personal_mx_primary" {
  name     = data.sops_file.secrets.data["personal.domain"]
  zone_id  = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value    = "in1-smtp.messagingengine.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_record" "personal_mx_secondary" {
  name     = data.sops_file.secrets.data["personal.domain"]
  zone_id  = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value    = "in2-smtp.messagingengine.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 20
}

resource "cloudflare_record" "personal_dmarc" {
  name     = "_dmarc"
  zone_id  = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value    = "v=DMARC1; p=none; rua=mailto:dmarc@${data.sops_file.secrets.data["personal.domain"]}"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "personal_spf" {
  name     = data.sops_file.secrets.data["personal.domain"]
  zone_id  = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value    = "v=spf1 include:spf.messagingengine.com ?all"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "personal_dkim_1" {
  name    = "fm1._domainkey"
  zone_id = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value   = "fm1.${data.sops_file.secrets.data["personal.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "personal_dkim_2" {
  name    = "fm2._domainkey"
  zone_id = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value   = "fm2.${data.sops_file.secrets.data["personal.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "personal_dkim_3" {
  name    = "fm3._domainkey"
  zone_id = lookup(data.cloudflare_zones.personal.zones[0], "id")
  value   = "fm3.${data.sops_file.secrets.data["personal.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_page_rule" "personal_redirect" {
  zone_id = lookup(data.cloudflare_zones.personal.zones[0], "id")
  target = "www.${data.sops_file.secrets.data["personal.domain"]}/*"
  priority = 1

  actions {
    forwarding_url {
      url = "https://${data.sops_file.secrets.data["personal.domain"]}/$1"
      status_code = 301
    }
  }
}

# manual overrides:
#   - dnssec
#   - strict ssl
#   - min tls version 1.2
#   - https rewrites
#   - auto minify
#   - http3
#   - websockets
#   - brotli
#   - rocket loader off
