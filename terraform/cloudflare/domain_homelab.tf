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
