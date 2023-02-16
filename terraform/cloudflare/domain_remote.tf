data "cloudflare_zones" "remote" {
  filter {
    name = data.sops_file.secrets.data["remote.domain"]
  }
}

resource "cloudflare_zone_dnssec" "remote" {
  zone_id = lookup(data.cloudflare_zones.remote.zones[0], "id")
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

resource "cloudflare_record" "remote_mx_primary" {
  name     = data.sops_file.secrets.data["remote.domain"]
  zone_id  = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value    = "in1-smtp.messagingengine.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 10
}

resource "cloudflare_record" "remote_mx_secondary" {
  name     = data.sops_file.secrets.data["remote.domain"]
  zone_id  = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value    = "in2-smtp.messagingengine.com"
  comment  = local.cf_comment
  proxied  = false
  type     = "MX"
  ttl      = 1
  priority = 20
}

resource "cloudflare_record" "remote_dmarc" {
  name     = "_dmarc"
  zone_id  = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value    = "v=DMARC1; p=none; rua=mailto:dmarc@${data.sops_file.secrets.data["remote.domain"]}"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "remote_spf" {
  name     = data.sops_file.secrets.data["remote.domain"]
  zone_id  = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value    = "v=spf1 include:spf.messagingengine.com ?all"
  comment  = local.cf_comment
  type     = "TXT"
}

resource "cloudflare_record" "remote_dkim_1" {
  name    = "fm1._domainkey"
  zone_id = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value   = "fm1.${data.sops_file.secrets.data["remote.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "remote_dkim_2" {
  name    = "fm2._domainkey"
  zone_id = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value   = "fm2.${data.sops_file.secrets.data["remote.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "remote_dkim_3" {
  name    = "fm3._domainkey"
  zone_id = lookup(data.cloudflare_zones.remote.zones[0], "id")
  value   = "fm3.${data.sops_file.secrets.data["remote.domain"]}.dkim.fmhosted.com"
  comment = local.cf_comment
  proxied = false
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_filter" "remote_countries" {
  zone_id     = lookup(data.cloudflare_zones.remote.zones[0], "id")
  description = "Requests originating from certain countries"
  expression  = "(not ip.geoip.country in {\"AT\" \"HR\" \"DE\" \"IT\" \"SI\"})"
}

resource "cloudflare_firewall_rule" "remote_countries" {
  zone_id     = lookup(data.cloudflare_zones.remote.zones[0], "id")
  description = "Block requests originating from certain countries"
  filter_id   = cloudflare_filter.remote_countries.id
  action      = "block"
}

resource "cloudflare_page_rule" "redirect" {
  zone_id = lookup(data.cloudflare_zones.remote.zones[0], "id")
  target = "www.${data.sops_file.secrets.data["remote.domain"]}/*"
  priority = 1

  actions {
    forwarding_url {
      url = "https://${data.sops_file.secrets.data["remote.domain"]}/$1"
      status_code = 301
    }
  }
}
