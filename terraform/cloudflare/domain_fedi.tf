data "cloudflare_zones" "fedi" {
  filter {
    name = data.sops_file.secrets.data["fedi.domain"]
  }
}

resource "cloudflare_record" "fedi_mx_primary" {
  name     = data.sops_file.secrets.data["fedi.domain"]
  zone_id  = lookup(data.cloudflare_zones.fedi.zones[0], "id")
  value    = "in1-smtp.messagingengine.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_record" "fedi_mx_secondary" {
  name     = data.sops_file.secrets.data["fedi.domain"]
  zone_id  = lookup(data.cloudflare_zones.fedi.zones[0], "id")
  value    = "in2-smtp.messagingengine.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 20
}

resource "cloudflare_record" "fedi_dmarc" {
  name     = "_dmarc"
  zone_id  = lookup(data.cloudflare_zones.fedi.zones[0], "id")
  value    = "v=DMARC1; p=none; rua=mailto:dmarc@${data.sops_file.secrets.data["fedi.domain"]}"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "fedi_spf" {
  name     = data.sops_file.secrets.data["fedi.domain"]
  zone_id  = lookup(data.cloudflare_zones.fedi.zones[0], "id")
  value    = "v=spf1 include:spf.messagingengine.com ?all"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "fedi_dkim_1" {
  name    = "fm1._domainkey"
  zone_id = lookup(data.cloudflare_zones.fedi.zones[0], "id")
  value   = "fm1.${data.sops_file.secrets.data["fedi.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "fedi_dkim_2" {
  name    = "fm2._domainkey"
  zone_id = lookup(data.cloudflare_zones.fedi.zones[0], "id")
  value   = "fm2.${data.sops_file.secrets.data["fedi.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "fedi_dkim_3" {
  name    = "fm3._domainkey"
  zone_id = lookup(data.cloudflare_zones.fedi.zones[0], "id")
  value   = "fm3.${data.sops_file.secrets.data["fedi.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

# manual overrides:
#   - dnssec
